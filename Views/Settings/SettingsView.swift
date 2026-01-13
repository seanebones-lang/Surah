//
//  SettingsView.swift
//  Seemi's Spiritual Companion
//
//  Application settings and preferences
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var bindableAppState = appState
        
        NavigationStack {
            ZStack {
                Color(hex: "#F1F8E9")
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(Color(hex: "#66BB6A"))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Seemi Warris")
                                    .font(.system(size: 22, weight: .semibold))
                                
                                Text("Exclusive User")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.leading, 8)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Section("Appearance") {
                        Toggle(isOn: $bindableAppState.isDarkMode) {
                            Label("Dark Mode", systemImage: "moon.fill")
                        }
                        .tint(Color(hex: "#66BB6A"))
                    }
                    
                    Section("Notifications") {
                        Toggle(isOn: $bindableAppState.notificationsEnabled) {
                            Label("Enable Notifications", systemImage: "bell.fill")
                        }
                        .tint(Color(hex: "#66BB6A"))
                        .onChange(of: bindableAppState.notificationsEnabled) { oldValue, newValue in
                            if newValue {
                                // Request notification permission
                                NotificationService.shared.requestAuthorization { granted in
                                    Task { @MainActor in
                                        if granted {
                                            // Request location for prayer times
                                            NotificationService.shared.requestLocation()
                                            // Schedule notifications
                                            NotificationService.shared.schedulePrayerNotifications()
                                            NotificationService.shared.scheduleDuaReminders()
                                        }
                                    }
                                }
                            }
                        }
                        
                        if bindableAppState.notificationsEnabled {
                            HStack {
                                Label("Prayer Times", systemImage: "clock.fill")
                                Spacer()
                                Text("5 Daily")
                                    .foregroundStyle(.secondary)
                            }
                            
                            HStack {
                                Label("Daily Duas", systemImage: "book.fill")
                                Spacer()
                                Text("3 Daily")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    Section("Prayer Settings") {
                        HStack {
                            Label("Time Zone", systemImage: "globe")
                            Spacer()
                            Text(bindableAppState.prayerTimeZone)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Label("Location", systemImage: "location.fill")
                            Spacer()
                            Text(NotificationService.shared.locationName)
                                .foregroundStyle(.secondary)
                        }
                        
                        Button(action: {
                            NotificationService.shared.requestLocation()
                        }) {
                            HStack {
                                Image(systemName: "location.circle")
                                Text("Update Location")
                                Spacer()
                            }
                        }
                    }
                    
                    Section("AI Settings") {
                        NavigationLink(destination: APIKeySettingsView()) {
                            HStack {
                                Label("xAI API Key", systemImage: "key.fill")
                                Spacer()
                                if NextElevenAPIService.shared.getAPIKey() != nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundStyle(.orange)
                                }
                            }
                        }
                        
                        HStack {
                            Label("Model", systemImage: "cpu")
                            Spacer()
                            Text("Grok 4.1 Fast Reasoning")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Label("Context Window", systemImage: "doc.text")
                            Spacer()
                            Text("2M tokens")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Label("Real-time Info", systemImage: "globe")
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    
                    Section("Voice Settings") {
                        HStack {
                            Label("Speech Recognition", systemImage: "mic.fill")
                            Spacer()
                            Text("Urdu + English")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Label("Text-to-Speech", systemImage: "speaker.wave.2.fill")
                            Spacer()
                            Text("Auto-detect")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Section("About") {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundStyle(.secondary)
                        }
                        
                        
                        Link(destination: URL(string: "https://x.ai")!) {
                            HStack {
                                Text("Powered by xAI Grok")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                        }
                        
                        Link(destination: URL(string: "https://console.x.ai")!) {
                            HStack {
                                Text("xAI Console (API Keys)")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                        }
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            // Clear chat history
                        } label: {
                            Label("Clear Chat History", systemImage: "trash")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}
