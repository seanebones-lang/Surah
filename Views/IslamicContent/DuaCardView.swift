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
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color(hex: "#1B5E20"))
                    
                    Text(item.source)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(hex: "#66BB6A"))
            }
            
            if isExpanded {
                Divider()
                
                // Arabic Text (RTL)
                VStack(alignment: .trailing, spacing: 12) {
                    Text(item.arabicText)
                        .font(.system(size: 22, weight: .medium))
                        .multilineTextAlignment(.trailing)
                        .environment(\.layoutDirection, .rightToLeft)
                        .foregroundStyle(Color(hex: "#1B5E20"))
                        .lineSpacing(8)
                        .onTapGesture {
                            showFullArabic.toggle()
                        }
                    
                    if item.repeatCount > 1 {
                        HStack {
                            Image(systemName: "repeat")
                                .font(.system(size: 12))
                            Text("Recite \(item.repeatCount)x")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(Color(hex: "#F57C00"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "#FFF3E0"))
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical, 8)
                
                // English Translation
                Text(item.englishTranslation)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.primary)
                    .lineSpacing(4)
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
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.primary)
                                    
                                    Text("Authentic Dua recitation with Urdu translation")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.secondary)
                                    
                                    if item.repeatCount > 1 {
                                        Text("🔁 Recite \(item.repeatCount) times")
                                            .font(.system(size: 13))
                                            .foregroundStyle(Color(hex: "#F57C00"))
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right")
                                    .foregroundStyle(Color(hex: "#66BB6A"))
                            }
                            .padding()
                            .background(Color.white)
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
                                    .font(.system(size: 16, weight: .medium))
                                Text("This Dua is best recited in your own voice")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if item.repeatCount > 1 {
                            Text("💡 Recite \(item.repeatCount) times for maximum benefit")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(hex: "#F57C00"))
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color(hex: "#FFF3E0"))
                    .cornerRadius(12)
                    .padding(.top, 8)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
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
                        .font(.system(size: 28, weight: .medium))
                        .multilineTextAlignment(.trailing)
                        .environment(\.layoutDirection, .rightToLeft)
                        .foregroundStyle(Color(hex: "#1B5E20"))
                        .lineSpacing(12)
                        .padding()
                }
            }
            .background(Color(hex: "#F1F8E9"))
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(audioPlayer.isPlaying && audioPlayer.currentItemID == item.id ? "Playing..." : "Tap to Play")
                        .font(.system(size: 16, weight: .medium))
                    
                    if audioPlayer.isPlaying && audioPlayer.currentItemID == item.id {
                        Text(formatTime(audioPlayer.currentTime) + " / " + formatTime(audioPlayer.duration))
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Recitation with translation")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                // Download Button
                Button(action: downloadAudio) {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 28))
                        .foregroundStyle(Color(hex: "#66BB6A"))
                }
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
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                ForEach([0.5, 0.75, 1.0, 1.25, 1.5, 2.0], id: \.self) { speed in
                    Button(action: {
                        playbackSpeed = Float(speed)
                        audioPlayer.setSpeed(Float(speed))
                    }) {
                        Text("\(speed, specifier: "%.2g")x")
                            .font(.system(size: 14, weight: playbackSpeed == Float(speed) ? .bold : .regular))
                            .foregroundStyle(playbackSpeed == Float(speed) ? Color(hex: "#66BB6A") : .secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(playbackSpeed == Float(speed) ? Color(hex: "#E8F5E9") : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color(hex: "#F9FBF9"))
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
                print("Download failed: \(error)")
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
