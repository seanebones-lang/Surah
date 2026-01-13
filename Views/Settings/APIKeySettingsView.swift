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
    @State private var isSecure: Bool = true
    
    private let apiService = NextElevenAPIService.shared
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("xAI API Key")
                        .font(.headline)
                    
                    Text("Your key is securely stored in iOS Keychain")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        if isSecure {
                            SecureField("Enter API key", text: $apiKey)
                        } else {
                            TextField("Enter API key", text: $apiKey)
                        }
                        
                        Button(action: { isSecure.toggle() }) {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                }
            } header: {
                Text("API Configuration")
            } footer: {
                Text("Your xAI API key is stored securely in the iOS Keychain (encrypted) and never shared. Get more keys at console.x.ai")
            }
            
            Section {
                Button(action: saveAPIKey) {
                    HStack {
                        Spacer()
                        Text("Save API Key")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(apiKey.isEmpty)
                
                Button(role: .destructive, action: deleteAPIKey) {
                    HStack {
                        Spacer()
                        Text("Delete API Key")
                        Spacer()
                    }
                }
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
        .onAppear {
            // Load existing key (masked)
            if let existingKey = apiService.getAPIKey() {
                apiKey = String(repeating: "•", count: 20) + existingKey.suffix(4)
            }
        }
    }
    
    private func saveAPIKey() {
        guard !apiKey.isEmpty else { return }
        
        apiService.saveAPIKey(apiKey)
        showSuccess = true
        
        // Haptic feedback
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
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
