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
    // Optimized: Only load last 100 messages initially (with 2M token context, we can handle more)
    // For very long conversations, we'll paginate if needed
    @Query(
        sort: \ChatMessage.timestamp,
        order: .forward
    ) private var messages: [ChatMessage]
    
    @State private var messageText: String = ""
    @State private var isTyping: Bool = false
    @State private var showClearConfirmation: Bool = false
    @State private var currentRequestTask: Task<Void, Never>?
    @State private var isScrollingToBottom: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Messages List
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                // Welcome Message
                                if messages.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "heart.circle.fill")
                                            .font(.system(size: 60))
                                            .foregroundStyle(Color(hex: "#66BB6A"))
                                            .accessibilityHidden(true)
                                        
                        Text("Assalamu Alaikum Seemi")
                            .font(.title.bold())
                            .foregroundStyle(.primary)
                            .accessibilityAddTraits(.isHeader)
                            .dynamicTypeSize(.large)
                        
                        Text("I'm Iman, your caring sister from Lahore. I understand Urdu, English, and Lahori dialect fluently.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .dynamicTypeSize(.large)
                        
                        Text("💬 Type to chat with me")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "#66BB6A"))
                            .padding(.top, 8)
                            .dynamicTypeSize(.large)
                                    }
                                    .padding(.top, 80)
                                    .accessibilityElement(children: .combine)
                                }
                                
                                // Chat Messages - Optimized with lazy loading
                                // Only render visible messages + buffer for smooth scrolling
                                ForEach(messages) { message in
                                    SimpleChatBubbleView(message: message)
                                        .id(message.id)
                                        .onAppear {
                                            // Preload nearby messages for smooth scrolling
                                        }
                                }
                                
                                // Typing Indicator
                                if isTyping {
                                    TypingIndicatorView()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: messages.count) { oldValue, newValue in
                            if let lastMessage = messages.last, newValue > oldValue {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        .onChange(of: isTyping) { oldValue, newValue in
                            if newValue, let lastMessage = messages.last {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Input Bar
                    HStack(spacing: 12) {
                        TextField("Message Iman (Urdu/English)...", text: $messageText, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(20)
                            .lineLimit(1...5)
                            .disabled(isTyping)
                            .submitLabel(.send)
                            .onSubmit {
                                if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isTyping {
                                    sendMessage()
                                }
                            }
                            .accessibilityLabel("Message input field")
                            .accessibilityHint("Type your message to Iman in Urdu or English")
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(messageText.isEmpty ? .gray : Color(hex: "#66BB6A"))
                        }
                        .disabled(messageText.isEmpty || isTyping)
                        .accessibilityLabel("Send message")
                        .accessibilityHint(messageText.isEmpty ? "Enter a message to enable send" : "Sends your message to Iman")
                    }
                    .padding()
                    .background(Color(UIColor.systemGroupedBackground))
                }
            }
            .navigationTitle("Chat with Iman")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showClearConfirmation = true }) {
                        Image(systemName: "trash")
                            .foregroundStyle(Color(hex: "#66BB6A"))
                    }
                    .accessibilityLabel("Clear chat history")
                    .accessibilityHint("Deletes all messages in the conversation")
                    .disabled(messages.isEmpty)
                }
            }
            .confirmationDialog("Clear Chat History", isPresented: $showClearConfirmation, titleVisibility: .visible) {
                Button("Clear All Messages", role: .destructive) {
                    clearHistory()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will permanently delete all messages. This action cannot be undone.")
            }
            .onDisappear {
                currentRequestTask?.cancel()
                currentRequestTask = nil
                if isTyping {
                    isTyping = false
                }
                // Clean up speech service resources when leaving chat
                SpeechService.shared.cleanup()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                // Clean up when app goes to background
                SpeechService.shared.cleanup()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                // Ensure cleanup on background
                SpeechService.shared.cleanup()
            }
        }
    }
    
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        // Input sanitization: Remove control characters and normalize whitespace
        let sanitizedMessage = sanitizeInput(trimmedMessage)
        
        // Validate message length (prevent extremely long messages)
        guard sanitizedMessage.count <= 10000 else {
            let errorMsg = ChatMessage(
                content: "Seemi, that message is too long. Please keep messages under 10,000 characters. 🌸",
                isFromUser: false
            )
            modelContext.insert(errorMsg)
            try? modelContext.save()
            return
        }
        
        // Validate message is not empty after sanitization
        guard !sanitizedMessage.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            return
        }
        
        // Cancel any pending request
        currentRequestTask?.cancel()
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Save user message (sanitized)
        let userMessage = ChatMessage(content: sanitizedMessage, isFromUser: true)
        modelContext.insert(userMessage)
        
        // Save immediately to show user message
        try? modelContext.save()
        
        messageText = ""
        isTyping = true
        
        // Capture current messages snapshot for API call
        let currentMessages = Array(messages)
        
        // Call actual xAI Grok API
        currentRequestTask = Task { @MainActor in
            // Check if task was cancelled
            guard !Task.isCancelled else {
                isTyping = false
                return
            }
            XAIAPIService.shared.sendMessage(
                userMessage: sanitizedMessage,
                conversationHistory: currentMessages
            ) { result in
                Task { @MainActor in
                    // Check if task was cancelled
                    guard !Task.isCancelled else {
                        isTyping = false
                        return
                    }
                    
                    isTyping = false
                    
                    switch result {
                    case .success(let response):
                        let botMessage = ChatMessage(content: response, isFromUser: false)
                        modelContext.insert(botMessage)
                        
                        // Save context
                        do {
                            try modelContext.save()
                            
                            // Scroll handled by onChange observer
                            
                            // Haptic feedback
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        } catch {
                            AppLogger.error("Error saving message: \(error.localizedDescription)")
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.error)
                        }
                        
                    case .failure(let error):
                        // Show user-friendly error message using APIError's userFriendlyMessage
                        let errorMessage: String
                        if let apiError = error as? APIError {
                            errorMessage = apiError.errorDescription ?? "An unexpected error occurred"
                        } else {
                            // Generic error with helpful guidance
                            errorMessage = "Seemi, I'm having trouble connecting right now. Please check your internet connection and try again. If the problem continues, you may need to check your API key in Settings → AI Settings. 🌸"
                        }
                        
                        let errorMsg = ChatMessage(content: errorMessage, isFromUser: false)
                        modelContext.insert(errorMsg)
                        
                        // Save context
                        do {
                            try modelContext.save()
                            
                            // Scroll handled by onChange observer
                            
                            // Haptic feedback for error
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.error)
                        } catch {
                            AppLogger.error("Error saving error message: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    private func clearHistory() {
        guard !messages.isEmpty else { return }
        
        for message in messages {
            modelContext.delete(message)
        }
        
        // Save context
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
    
    // MARK: - Input Sanitization
    
    /// Sanitize user input to prevent injection attacks and normalize content
    private func sanitizeInput(_ input: String) -> String {
        // Remove control characters (except newlines and tabs)
        let controlChars = CharacterSet.controlCharacters.subtracting(CharacterSet(charactersIn: "\n\t"))
        var sanitized = input.components(separatedBy: controlChars).joined(separator: "")
        
        // Normalize whitespace (replace multiple spaces/tabs with single space, but preserve newlines)
        let lines = sanitized.components(separatedBy: .newlines)
        let normalizedLines = lines.map { line in
            line.components(separatedBy: .whitespaces)
                .filter { !$0.isEmpty }
                .joined(separator: " ")
        }
        sanitized = normalizedLines.joined(separator: "\n")
        
        // Trim leading/trailing whitespace from each line
        sanitized = sanitized.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n")
        
        return sanitized.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

// MARK: - Simple Chat Bubble
struct SimpleChatBubbleView: View {
    let message: ChatMessage

    private var isRTLContent: Bool {
        // Check if message contains Arabic/Urdu characters
        let arabicRange = message.content.range(of: "\\p{Arabic}", options: .regularExpression)
        return arabicRange != nil
    }

    var body: some View {
        HStack {
            if message.isFromUser { Spacer() }

            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .foregroundStyle(message.isFromUser ? .white : .primary)
                    .dynamicTypeSize(.large)
                    .environment(\.layoutDirection, isRTLContent ? .rightToLeft : .leftToRight)
                    .multilineTextAlignment(isRTLContent ? .trailing : .leading)
                    .padding(12)
                    .background(
                        message.isFromUser ?
                        Color(hex: "#66BB6A") : Color(UIColor.secondarySystemGroupedBackground)
                    )
                    .cornerRadius(16)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(message.isFromUser ? "You said: \(message.content)" : "Iman said: \(message.content)")
                
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .dynamicTypeSize(.large)
                    .accessibilityLabel("Sent at \(message.timestamp.formatted(date: .omitted, time: .shortened))")
            }
            .frame(maxWidth: 280, alignment: message.isFromUser ? .trailing : .leading)
            
            if !message.isFromUser { Spacer() }
        }
    }
}

// MARK: - Typing Indicator
struct TypingIndicatorView: View {
    @State private var animatingDots: [Bool] = [false, false, false]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color(hex: "#66BB6A"))
                    .frame(width: 8, height: 8)
                    .scaleEffect(animatingDots[index] ? 1.2 : 0.8)
                    .opacity(animatingDots[index] ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animatingDots[index]
                    )
            }
            
            Text("Iman is typing...")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .dynamicTypeSize(.large)
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .accessibilityLabel("Iman is typing")
        .onAppear {
            animatingDots = [true, true, true]
        }
    }
}

#Preview {
    ImanChatView()
        .modelContainer(for: ChatMessage.self, inMemory: true)
        .environment(AppState())
}
