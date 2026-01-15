//
//  DuaCardView.swift
//  Seemi's Spiritual Companion
//
//  Individual card component with audio support
//

import SwiftUI

struct DuaCardView: View {
    let item: IslamicContentItem
    let isExpanded: Bool
    
    @State private var isPlaying: Bool = false
    @State private var playbackSpeed: Double = 1.0
    @State private var showFullArabic: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(Color(hex: "#1B5E20"))
                        .dynamicTypeSize(.large)
                    
                    Text(item.source)
                        .font(.caption)
                        .foregroundStyle(Color(hex: "#558B2F"))
                        .dynamicTypeSize(.large)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(hex: "#66BB6A"))
                    .accessibilityHidden(true)
            }
            
            if isExpanded {
                Divider()
                
                // Arabic Text (RTL)
                VStack(alignment: .trailing, spacing: 12) {
                    Text(item.arabicText)
                        .font(.title2)
                        .multilineTextAlignment(.trailing)
                        .environment(\.layoutDirection, .rightToLeft)
                        .foregroundStyle(Color(hex: "#1B5E20"))
                        .lineSpacing(8)
                        .dynamicTypeSize(.large)
                        .onTapGesture {
                            showFullArabic.toggle()
                        }
                        .accessibilityLabel("Arabic text: \(item.arabicText)")
                        .accessibilityHint("Double tap to view full Arabic text in larger size")
                        .accessibilityAddTraits(.isButton)
                    
                    if item.repeatCount > 1 {
                        HStack {
                            Image(systemName: "repeat")
                                .font(.caption2)
                            Text("Recite \(item.repeatCount)x")
                                .font(.caption2)
                        }
                        .dynamicTypeSize(.large)
                        .foregroundStyle(Color(hex: "#F57C00"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(UIColor.tertiarySystemGroupedBackground))
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical, 8)
                
                // English Translation
                Text(item.englishTranslation)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineSpacing(4)
                    .dynamicTypeSize(.large)
                    .padding(.vertical, 8)
                
                // Audio Controls (Only show if audio available)
                if item.hasAudio {
                    // Check if it's a YouTube link
                    if let audioURL = item.audioURL, (audioURL.contains("youtu.be") || audioURL.contains("youtube.com")) {
                        // YouTube Link Button
                        Link(destination: URL(string: audioURL)!) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.rectangle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.red)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Watch on YouTube")
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                        .dynamicTypeSize(.large)
                                    
                                    Text("Authentic Dua recitation with Urdu translation")
                                        .font(.caption)
                                        .foregroundStyle(Color(hex: "#558B2F"))
                                        .dynamicTypeSize(.large)
                                    
                                    if item.repeatCount > 1 {
                                        Text("🔁 Recite \(item.repeatCount) times")
                                            .font(.caption2)
                                            .foregroundStyle(Color(hex: "#F57C00"))
                                            .dynamicTypeSize(.large)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right")
                                    .foregroundStyle(Color(hex: "#66BB6A"))
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#66BB6A"), lineWidth: 2)
                            )
                        }
                        .padding(.top, 8)
                    } else {
                        // Regular audio player for direct MP3 links
                        AudioControlsView(item: item, isPlaying: $isPlaying)
                            .padding(.top, 8)
                    }
                } else {
                    // No audio available - encourage personal recitation
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "book.closed")
                                .font(.system(size: 24))
                                .foregroundStyle(Color(hex: "#66BB6A"))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Read & Recite")
                                    .font(.body)
                                    .dynamicTypeSize(.large)
                            Text("This Dua is best recited in your own voice")
                                .font(.caption)
                                .foregroundStyle(Color(hex: "#558B2F"))
                                .dynamicTypeSize(.large)
                            }
                        }
                        
                        if item.repeatCount > 1 {
                            Text("💡 Recite \(item.repeatCount) times for maximum benefit")
                                .font(.caption2)
                                .foregroundStyle(Color(hex: "#F57C00"))
                                .dynamicTypeSize(.large)
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.top, 8)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .sheet(isPresented: $showFullArabic) {
            FullArabicView(item: item)
        }
    }
}

// MARK: - Full Arabic Text Modal
struct FullArabicView: View {
    let item: IslamicContentItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text(item.arabicText)
                        .font(.largeTitle)
                        .multilineTextAlignment(.trailing)
                        .environment(\.layoutDirection, .rightToLeft)
                        .foregroundStyle(Color(hex: "#1B5E20"))
                        .lineSpacing(12)
                        .dynamicTypeSize(.large)
                        .padding()
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle(item.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Audio Controls View
struct AudioControlsView: View {
    let item: IslamicContentItem
    @Binding var isPlaying: Bool
    
    @State private var currentTime: TimeInterval = 0
    @State private var duration: TimeInterval = 100
    @State private var playbackSpeed: Float = 1.0
    @State private var showSpeedMenu: Bool = false
    
    @State private var audioPlayer = AudioPlayerService.shared
    
    var body: some View {
        VStack(spacing: 12) {
            // Play/Pause + Download
            HStack(spacing: 20) {
                // Play/Pause Button
                Button(action: togglePlayback) {
                    Image(systemName: audioPlayer.isPlaying && audioPlayer.currentItemID == item.id ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(Color(hex: "#66BB6A"))
                }
                .accessibilityLabel(audioPlayer.isPlaying && audioPlayer.currentItemID == item.id ? "Pause audio" : "Play audio")
                .accessibilityHint("Plays the audio recitation for \(item.title)")
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(audioPlayer.isPlaying && audioPlayer.currentItemID == item.id ? "Playing..." : "Tap to Play")
                        .font(.body)
                        .dynamicTypeSize(.large)
                    
                    if audioPlayer.isPlaying && audioPlayer.currentItemID == item.id {
                        Text(formatTime(audioPlayer.currentTime) + " / " + formatTime(audioPlayer.duration))
                            .font(.caption)
                            .foregroundStyle(Color(hex: "#558B2F"))
                            .dynamicTypeSize(.large)
                    } else {
                        Text("Recitation with translation")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "#558B2F"))
                            .dynamicTypeSize(.large)
                    }
                }
                
                Spacer()
                
                // Download Button
                Button(action: downloadAudio) {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 28))
                        .foregroundStyle(Color(hex: "#66BB6A"))
                }
                .accessibilityLabel("Download audio")
                .accessibilityHint("Downloads audio for offline playback")
            }
            
            // Progress Slider
            if audioPlayer.isPlaying && audioPlayer.currentItemID == item.id {
                Slider(
                    value: Binding(
                        get: { audioPlayer.currentTime },
                        set: { audioPlayer.seek(to: $0) }
                    ),
                    in: 0...max(audioPlayer.duration, 1)
                )
                .tint(Color(hex: "#66BB6A"))
            }
            
            // Speed Control
            HStack {
                Text("Speed:")
                    .font(.caption)
                    .foregroundStyle(Color(hex: "#558B2F"))
                    .dynamicTypeSize(.large)
                
                ForEach([0.5, 0.75, 1.0, 1.25, 1.5, 2.0], id: \.self) { speed in
                    Button(action: {
                        playbackSpeed = Float(speed)
                        audioPlayer.setSpeed(Float(speed))
                    }) {
                        Text("\(speed, specifier: "%.2g")x")
                            .font(.caption.weight(playbackSpeed == Float(speed) ? .bold : .regular))
                            .foregroundStyle(playbackSpeed == Float(speed) ? Color(hex: "#66BB6A") : Color(hex: "#558B2F"))
                            .dynamicTypeSize(.large)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(playbackSpeed == Float(speed) ? Color(hex: "#E8F5E9") : Color.clear)
                            .cornerRadius(8)
                    }
                    .accessibilityLabel("Playback speed \(speed, specifier: "%.2g")x")
                    .accessibilityAddTraits(playbackSpeed == Float(speed) ? .isSelected : [])
                }
            }
        }
        .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private func togglePlayback() {
        if audioPlayer.isPlaying && audioPlayer.currentItemID == item.id {
            audioPlayer.pause()
            isPlaying = false
        } else {
            audioPlayer.play(item: item)
            isPlaying = true
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    private func downloadAudio() {
        audioPlayer.downloadAudio(for: item) { result in
            switch result {
            case .success:
                // Show success feedback
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            case .failure(let error):
                AppLogger.error("Audio download failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    DuaCardView(
        item: IslamicContentItem.allItems[0],
        isExpanded: true
    )
    .padding()
}
