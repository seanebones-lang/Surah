//
//  ImanChatView.swift
//  Seemi's Spiritual Companion
//
//  AI chat interface with xAI Grok integration
//

import SwiftUI
import SwiftData

struct ImanChatView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatMessage.timestamp) private var messages: [ChatMessage]
    
    @State private var messageText: String = ""
    @State private var isTyping: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(hex: "#F5F5F5")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Messages List
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 16) {
                                // Welcome Message
                                if messages.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "heart.circle.fill")
                                            .font(.system(size: 60))
                                            .foregroundStyle(Color(hex: "#66BB6A"))
                                        
                        Text("Assalamu Alaikum Seemi")
                            .font(.system(size: 24, weight: .semibold))
                        
                        Text("I'm Iman, your caring sister from Lahore. I understand Urdu, English, and Lahori dialect fluently.")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text("💬 Type to chat with me")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(hex: "#66BB6A"))
                            .padding(.top, 8)
                                    }
                                    .padding(.top, 80)
                                }
                                
                                // Chat Messages
                                ForEach(messages) { message in
                                    SimpleChatBubbleView(message: message)
                                        .id(message.id)
                                }
                                
                                // Typing Indicator
                                if isTyping {
                                    HStack(spacing: 8) {
                                        ForEach(0..<3) { index in
                                            Circle()
                                                .fill(Color(hex: "#66BB6A"))
                                                .frame(width: 8, height: 8)
                                        }
                                        
                                        Text("Iman is typing...")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: messages.count) { oldValue, newValue in
                            if let lastMessage = messages.last {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    // Input Bar
                    HStack(spacing: 12) {
                        TextField("Message Iman (Urdu/English)...", text: $messageText, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(20)
                            .lineLimit(1...5)
                            .disabled(isTyping)
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(messageText.isEmpty ? .gray : Color(hex: "#66BB6A"))
                        }
                        .disabled(messageText.isEmpty || isTyping)
                    }
                    .padding()
                    .background(Color(hex: "#F5F5F5"))
                }
            }
            .navigationTitle("Chat with Iman")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: clearHistory) {
                        Image(systemName: "trash")
                            .foregroundStyle(Color(hex: "#66BB6A"))
                    }
                }
            }
        }
    }
    
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Save user message
        let userMessage = ChatMessage(content: trimmedMessage, isFromUser: true)
        modelContext.insert(userMessage)
        
        messageText = ""
        isTyping = true
        
        // Call actual xAI Grok API
        Task { @MainActor in
            NextElevenAPIService.shared.sendMessage(
                userMessage: trimmedMessage,
                conversationHistory: messages
            ) { result in
                Task { @MainActor in
                    isTyping = false
                    
                    switch result {
                    case .success(let response):
                        let botMessage = ChatMessage(content: response, isFromUser: false)
                        modelContext.insert(botMessage)
                        
                        // Haptic feedback
                        let notification = UINotificationFeedbackGenerator()
                        notification.notificationOccurred(.success)
                        
                    case .failure(let error):
                        // Show error and fallback
                        let errorMsg = ChatMessage(
                            content: "Seemi, I'm having trouble connecting. Error: \(error.localizedDescription). Please check your internet connection and API key in Settings.",
                            isFromUser: false
                        )
                        modelContext.insert(errorMsg)
                    }
                }
            }
        }
    }
    
    private func clearHistory() {
        for message in messages {
            modelContext.delete(message)
        }
        
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
    }
}

// MARK: - Simple Chat Bubble
struct SimpleChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser { Spacer() }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(size: 16))
                    .foregroundStyle(message.isFromUser ? .white : .primary)
                    .padding(12)
                    .background(
                        message.isFromUser ?
                        Color(hex: "#66BB6A") : Color.white
                    )
                    .cornerRadius(16)
                
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 280, alignment: message.isFromUser ? .trailing : .leading)
            
            if !message.isFromUser { Spacer() }
        }
    }
}

#Preview {
    ImanChatView()
        .modelContainer(for: ChatMessage.self, inMemory: true)
        .environment(AppState())
}
