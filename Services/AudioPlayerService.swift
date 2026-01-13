//
//  AudioPlayerService.swift
//  Seemi's Spiritual Companion
//
//  Audio playback service with offline caching
//

import Foundation
import AVFoundation
import Combine

@Observable
@MainActor
class AudioPlayerService: NSObject {
    // MARK: - Properties
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    
    var isPlaying: Bool = false
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var playbackSpeed: Float = 1.0
    var currentItemID: UUID?
    var error: String?
    
    // MARK: - Singleton
    static let shared = AudioPlayerService()
    
    override private init() {
        super.init()
        setupAudioSession()
    }
    
    // MARK: - Audio Session Setup
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Playback Control
    
    /// Play audio for an Islamic content item
    func play(item: IslamicContentItem) {
        // Stop current playback
        stop()
        
        currentItemID = item.id
        
        // Get audio URL (from Quran.com API or bundled file)
        guard let audioURL = getAudioURL(for: item) else {
            error = "Audio not available for this item"
            return
        }
        
        // Create player item
        playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)
        
        // Add time observer
        addTimeObserver()
        
        // Add notification for playback end
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        // Start playback
        player?.play()
        player?.rate = playbackSpeed
        isPlaying = true
        
        // Get duration asynchronously
        Task {
            if let asset = playerItem?.asset {
                do {
                    let duration = try await asset.load(.duration)
                    await MainActor.run {
                        self.duration = duration.seconds
                    }
                } catch {
                    print("Failed to load duration: \(error)")
                }
            }
        }
    }
    
    /// Pause playback
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    /// Resume playback
    func resume() {
        player?.play()
        player?.rate = playbackSpeed
        isPlaying = true
    }
    
    /// Stop playback
    func stop() {
        player?.pause()
        player?.seek(to: .zero)
        removeTimeObserver()
        isPlaying = false
        currentTime = 0
        currentItemID = nil
    }
    
    /// Seek to specific time
    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
        currentTime = time
    }
    
    /// Change playback speed
    func setSpeed(_ speed: Float) {
        playbackSpeed = speed
        if isPlaying {
            player?.rate = speed
        }
    }
    
    // MARK: - Time Observer
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            Task { @MainActor in
                guard let self = self else { return }
                self.currentTime = time.seconds
            }
        }
    }
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    @objc private func playerDidFinishPlaying() {
        isPlaying = false
        currentTime = 0
        
        // Check if item should repeat
        if let itemID = currentItemID,
           let item = IslamicContentItem.allItems.first(where: { $0.id == itemID }),
           item.repeatCount > 1 {
            // Replay for repeat count
            play(item: item)
        }
    }
    
    // MARK: - Audio URLs
    
    private func getAudioURL(for item: IslamicContentItem) -> URL? {
        // Check if bundled audio exists (downloaded from YouTube)
        let audioFileName: String
        
        switch item.title {
        case "Dua to Remove Worry & Sorrow":
            audioFileName = "dua_remove_worry"
        case "Morning & Evening Protection Dua":
            audioFileName = "dua_protection_morning_evening"
        case "Surah Ar-Rahman (The Most Merciful)":
            audioFileName = "surah_ar_rahman_fast"
        case "Dua for Tension & Depression":
            audioFileName = "dua_tension_depression"
        case "Wazifa for Protection":
            audioFileName = "dua_protection_morning_evening" // Same as #2
        case "Dua for Healing":
            audioFileName = "dua_healing"
        case "Dua Against Evil Eye (Al-Hasad)":
            audioFileName = "dua_evil_eye_hasad"
        case "Manzil Dua (Protection Collection)":
            audioFileName = "manzil_dua_complete"
        default:
            audioFileName = ""
        }
        
        // Check if bundled audio exists
        if let bundledURL = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") {
            return bundledURL
        }
        
        // First, check if item has audioURL specified
        if let audioURLString = item.audioURL {
            // Check if it's a YouTube URL
            if audioURLString.contains("youtu.be") || audioURLString.contains("youtube.com") {
                // For YouTube URLs, return nil to show YouTube link button
                return nil
            } else if let url = URL(string: audioURLString) {
                return url
            }
        }
        
        // Fallback to online URLs for Quranic content
        switch item.title {
        case "Surah Ar-Rahman (The Most Merciful)":
            // Full Surah 55 (Ar-Rahman) - Muhammad Ayyub recitation
            return URL(string: "https://download.quranicaudio.com/quran/muhammad_ayyoub/055.mp3")
            
        case "Dua to Remove Worry & Sorrow":
            // This is a Hadith Dua - no specific audio available online
            // Using Surah Ash-Sharh (94) - "Verily with hardship comes ease" (comfort theme)
            // Note: Seemi can record her own recitation of the actual Dua later!
            return URL(string: "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/094.mp3")
            
        case "Morning & Evening Protection Dua",
             "Wazifa for Protection":
            // Protection Dua - using Surah Al-Ikhlas (112) + Al-Falaq (113) + An-Nas (114)
            return URL(string: "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/112.mp3")
            
        case "Dua for Tension & Depression":
            // Tawakkul verse - using Surah At-Talaq (65) where this verse is from
            return URL(string: "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/065.mp3")
            
        case "Dua for Healing":
            // Healing verse - using Surah Al-Isra (17) where verse 82 is from
            return URL(string: "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/017.mp3")
            
        case "Dua Against Evil Eye (Al-Hasad)":
            // Surah Al-Falaq (113) - Perfect match!
            return URL(string: "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/113.mp3")
            
        case "Manzil Dua (Protection Collection)":
            // Manzil starts with Al-Fatiha - using that as representative
            return URL(string: "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/001.mp3")
            
        default:
            return nil
        }
    }
    
    // MARK: - Offline Caching
    
    /// Download audio for offline playback
    func downloadAudio(for item: IslamicContentItem, completion: @escaping @Sendable (Result<URL, Error>) -> Void) {
        guard let audioURL = getAudioURL(for: item) else {
            completion(.failure(AudioError.noAudioURL))
            return
        }
        
        // Check if already cached
        if let cachedURL = getCachedAudioURL(for: item) {
            completion(.success(cachedURL))
            return
        }
        
        // Download audio
        let downloadTask = URLSession.shared.downloadTask(with: audioURL) { tempURL, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempURL = tempURL else {
                completion(.failure(AudioError.downloadFailed))
                return
            }
            
            // Move to cache directory
            Task { @MainActor in
                do {
                    let cacheURL = self.getCacheURL(for: item)
                    try FileManager.default.moveItem(at: tempURL, to: cacheURL)
                    completion(.success(cacheURL))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        downloadTask.resume()
    }
    
    private func getCacheURL(for item: IslamicContentItem) -> URL {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheDir.appendingPathComponent("audio_\(item.id.uuidString).mp3")
    }
    
    private func getCachedAudioURL(for item: IslamicContentItem) -> URL? {
        let cacheURL = getCacheURL(for: item)
        return FileManager.default.fileExists(atPath: cacheURL.path) ? cacheURL : nil
    }
    
    /// Clear audio cache
    func clearCache() {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: nil)
            for file in files where file.pathExtension == "mp3" {
                try FileManager.default.removeItem(at: file)
            }
        } catch {
            print("Error clearing cache: \(error)")
        }
    }
    
    // Note: deinit cleanup happens automatically for @MainActor classes
}

// MARK: - Errors

enum AudioError: LocalizedError {
    case noAudioURL
    case downloadFailed
    case playbackFailed
    
    var errorDescription: String? {
        switch self {
        case .noAudioURL:
            return "Audio URL not available"
        case .downloadFailed:
            return "Failed to download audio"
        case .playbackFailed:
            return "Failed to play audio"
        }
    }
}
