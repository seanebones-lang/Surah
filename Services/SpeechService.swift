//
//  SpeechService.swift
//  Seemi's Spiritual Companion
//
//  Speech recognition and text-to-speech (Urdu + English)
//

import Foundation
import Speech
import AVFoundation

@Observable
@MainActor
class SpeechService: NSObject {
    // MARK: - Properties
    private let speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    var isRecording: Bool = false
    var isAuthorized: Bool = false
    var recognizedText: String = ""
    var error: String?
    
    // MARK: - Singleton
    static let shared = SpeechService()
    
    override private init() {
        // Initialize with Urdu locale (Pakistan)
        // Falls back to English if Urdu not available
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ur-PK")) 
            ?? SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        
        super.init()
        
        speechSynthesizer.delegate = self
    }
    
    // MARK: - Authorization
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self?.isAuthorized = true
                    completion(true)
                case .denied, .restricted, .notDetermined:
                    self?.isAuthorized = false
                    self?.error = "Speech recognition not authorized"
                    completion(false)
                @unknown default:
                    self?.isAuthorized = false
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Speech Recognition (Voice Input)
    
    /// Start recording and recognizing speech (Urdu + English)
    func startRecording(completion: @escaping (String) -> Void) throws {
        // Cancel any ongoing task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechError.recognitionRequestFailed
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Configure audio input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        isRecording = true
        recognizedText = ""
        
        // Start recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.isRecording = false
                
                if isFinal {
                    completion(self.recognizedText)
                }
            }
        }
    }
    
    /// Stop recording
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
    }
    
    // MARK: - Text-to-Speech (Voice Output)
    
    /// Speak text aloud (supports Urdu + English)
    func speak(_ text: String, language: SpeechLanguage = .auto) {
        let utterance = AVSpeechUtterance(string: text)
        
        // Detect language and set voice
        let detectedLanguage = detectLanguage(text)
        
        switch language {
        case .auto:
            utterance.voice = getVoice(for: detectedLanguage)
        case .urdu:
            utterance.voice = getVoice(for: .urdu)
        case .english:
            utterance.voice = getVoice(for: .english)
        }
        
        // Configure speech parameters
        utterance.rate = 0.5 // Slightly slower for clarity
        utterance.pitchMultiplier = 1.1 // Slightly higher pitch (feminine)
        utterance.volume = 1.0
        
        speechSynthesizer.speak(utterance)
    }
    
    /// Stop speaking
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    // MARK: - Language Detection
    
    private func detectLanguage(_ text: String) -> SpeechLanguage {
        // Simple heuristic: if text contains Urdu script, it's Urdu
        let urduRange = text.range(
            of: "[\\u0600-\\u06FF]",
            options: .regularExpression
        )
        
        return urduRange != nil ? .urdu : .english
    }
    
    private func getVoice(for language: SpeechLanguage) -> AVSpeechSynthesisVoice? {
        switch language {
        case .urdu:
            // Try to get Urdu voice, fallback to Hindi (similar pronunciation)
            return AVSpeechSynthesisVoice(language: "ur-PK")
                ?? AVSpeechSynthesisVoice(language: "hi-IN")
                ?? AVSpeechSynthesisVoice(language: "en-US")
        case .english:
            // Use US English female voice
            return AVSpeechSynthesisVoice(language: "en-US")
        case .auto:
            return nil
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension SpeechService: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        // Speech started
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // Speech finished
    }
}

// MARK: - Supporting Types

enum SpeechLanguage {
    case urdu
    case english
    case auto
}

enum SpeechError: LocalizedError {
    case recognitionRequestFailed
    case audioEngineFailed
    case notAuthorized
    
    var errorDescription: String? {
        switch self {
        case .recognitionRequestFailed:
            return "Failed to create speech recognition request"
        case .audioEngineFailed:
            return "Audio engine failed to start"
        case .notAuthorized:
            return "Speech recognition not authorized"
        }
    }
}
