//
//  ChatHistorySettingsView.swift
//  Seemi's Spiritual Companion
//
//  Chat history management settings
//

import SwiftUI
import SwiftData

struct ChatHistorySettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatMessage.timestamp) private var messages: [ChatMessage]
    
    @State private var showClearConfirmation: Bool = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Label("Total Messages", systemImage: "message.fill")
                    Spacer()
                    Text("\(messages.count)")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Label("Oldest Message", systemImage: "clock.fill")
                    Spacer()
                    if let oldest = messages.first {
                        Text(oldest.timestamp.formatted(date: .abbreviated, time: .omitted))
                            .foregroundStyle(.secondary)
                    } else {
                        Text("No messages")
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Statistics")
            }
            
            Section {
                Button(role: .destructive, action: { showClearConfirmation = true }) {
                    HStack {
                        Spacer()
                        Label("Clear All Messages", systemImage: "trash")
                        Spacer()
                    }
                }
                .disabled(messages.isEmpty)
                .accessibilityLabel("Clear all chat messages")
                .accessibilityHint("Permanently deletes all messages in the conversation")
            } header: {
                Text("Danger Zone")
            } footer: {
                Text("This action cannot be undone. All chat history will be permanently deleted.")
            }
        }
        .navigationTitle("Chat History")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Clear All Messages", isPresented: $showClearConfirmation, titleVisibility: .visible) {
            Button("Clear All Messages", role: .destructive) {
                clearHistory()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete all \(messages.count) messages. This action cannot be undone.")
        }
    }
    
    private func clearHistory() {
        guard !messages.isEmpty else { return }
        
        for message in messages {
            modelContext.delete(message)
        }
        
        do {
            try modelContext.save()
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        } catch {
            AppLogger.error("Error clearing history: \(error.localizedDescription)")
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
        }
    }
}

#Preview {
    NavigationStack {
        ChatHistorySettingsView()
            .modelContainer(for: ChatMessage.self, inMemory: true)
    }
}
