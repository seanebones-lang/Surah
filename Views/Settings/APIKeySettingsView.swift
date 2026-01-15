//
//  APIKeySettingsView.swift
//  Seemi's Spiritual Companion
//
//  xAI API key configuration
//

import SwiftUI

struct APIKeySettingsView: View {
    @State private var apiKey: String = ""
    @State private var showSuccess: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSecure: Bool = true
    @State private var isSaving: Bool = false
    
    private let apiService = XAIAPIService.shared
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    if apiService.getAPIKey() != nil {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("API Key Configured")
                                .font(.headline)
                        }
                        
                        Text("Your API key is securely stored in iOS Keychain")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            if isSecure {
                                SecureField("API key", text: .constant(apiKey))
                                    .disabled(true)
                            } else {
                                TextField("API key", text: .constant(apiKey))
                                    .disabled(true)
                            }
                            
                            Button(action: { isSecure.toggle() }) {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundStyle(.secondary)
                            }
                            .accessibilityLabel(isSecure ? "Show API key" : "Hide API key")
                            .accessibilityHint("Toggles visibility of the API key")
                        }
                        .textFieldStyle(.roundedBorder)
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                Text("API Key Required")
                                    .font(.headline)
                            }
                            
                            Text("Please enter your xAI API key to enable chat with Iman")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                if isSecure {
                                    SecureField("Enter your xAI API key", text: $apiKey)
                                } else {
                                    TextField("Enter your xAI API key", text: $apiKey)
                                }
                                
                                Button(action: { isSecure.toggle() }) {
                                    Image(systemName: isSecure ? "eye.slash" : "eye")
                                        .foregroundStyle(.secondary)
                                }
                                .accessibilityLabel(isSecure ? "Show API key" : "Hide API key")
                            }
                            .textFieldStyle(.roundedBorder)
                            
                            Button(action: saveAPIKey) {
                                HStack {
                                    if isSaving {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                    } else {
                                        Image(systemName: "lock.shield.fill")
                                        Text("Save API Key")
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(apiKey.isEmpty || isSaving)
                            .accessibilityLabel("Save API key to Keychain")
                        }
                    }
                }
            } header: {
                Text("API Configuration")
            } footer: {
                if apiService.getAPIKey() != nil {
                    Text("Your xAI API key is stored securely in the iOS Keychain (encrypted). You can update it anytime.")
                } else {
                    Text("Get your API key from https://console.x.ai. The key will be stored securely in iOS Keychain.")
                }
            }
            
            if apiService.getAPIKey() != nil {
                Section {
                    Button(role: .destructive, action: deleteAPIKey) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete API Key")
                        }
                    }
                    .accessibilityLabel("Delete API key from Keychain")
                } header: {
                    Text("Manage Key")
                } footer: {
                    Text("Deleting the API key will disable chat functionality until a new key is added.")
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: apiService.getAPIKey() != nil ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(apiService.getAPIKey() != nil ? .green : .orange)
                        Text(apiService.getAPIKey() != nil ? "API Key Configured" : "API Key Required")
                            .font(.headline)
                        Text(apiService.getAPIKey() != nil ? "Ready to chat with Iman" : "Add API key to enable chat")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 20)
            } header: {
                Text("Status")
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Powered by xAI Grok", systemImage: "sparkles")
                        .foregroundStyle(Color(hex: "#66BB6A"))
                        .font(.headline)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    Label("Iman understands:", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(Color(hex: "#66BB6A"))
                    
                    Text("• English (fluent)")
                    Text("• Urdu (اردو - fluent)")
                    Text("• Lahori Punjabi dialect")
                    Text("• Code-switching (mixing languages)")
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    Label("Features:", systemImage: "star.fill")
                        .foregroundStyle(Color(hex: "#66BB6A"))
                    
                    Text("• 2M token context window")
                    Text("• Real-time information access")
                    Text("• Remembers full conversation")
                    Text("• Islamic knowledge (Quran/Hadith)")
                    Text("• Lahore culture & history")
                    Text("• Emotional support & guidance")
                    Text("• Low hallucination rate")
                }
                .font(.system(size: 14))
            } header: {
                Text("Iman's Capabilities (xAI Grok)")
            }
        }
        .navigationTitle("API Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Success!", isPresented: $showSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("xAI API key saved successfully to Keychain! You can now chat with Iman in Urdu/English. 🌸")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            // Load existing key (masked) if configured
            if let existingKey = apiService.getAPIKey() {
                // Show masked version - last 4 characters visible
                let maskedLength = max(20, existingKey.count - 4)
                apiKey = String(repeating: "•", count: maskedLength) + existingKey.suffix(4)
            } else {
                // No key configured - user needs to enter one
                apiKey = ""
            }
        }
    }
    
    private func saveAPIKey() {
        guard !apiKey.isEmpty else { return }
        
        // Validate API key format (xAI keys typically start with xai-)
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedKey.isEmpty {
            errorMessage = "API key cannot be empty."
            showError = true
            return
        }
        
        // Basic validation - xAI keys are typically long strings
        if trimmedKey.count < 20 {
            errorMessage = "API key appears to be invalid. Please check and try again."
            showError = true
            return
        }
        
        isSaving = true
        
        // Save to keychain
        apiService.saveAPIKey(trimmedKey)
        
        // Verify it was saved
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isSaving = false
            
            if apiService.getAPIKey() != nil {
                showSuccess = true
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            } else {
                errorMessage = "Failed to save API key. Please try again."
                showError = true
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.error)
            }
        }
    }
    
    private func deleteAPIKey() {
        apiService.deleteAPIKey()
        apiKey = ""
        
        // Haptic feedback
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
    }
}

#Preview {
    NavigationStack {
        APIKeySettingsView()
    }
}
