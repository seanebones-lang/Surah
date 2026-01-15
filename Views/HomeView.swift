//
//  HomeView.swift
//  Seemi's Spiritual Companion
//
//  Main navigation with 3 tabs
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTab: Int = 0
    
    var body: some View {
        @Bindable var bindableAppState = appState
        
        TabView(selection: $selectedTab) {
            // Tab 1: Islamic Content
            IslamicContentView()
                .tabItem {
                    Label("Islamic Content", systemImage: "book.closed")
                }
                .tag(0)
                .accessibilityLabel("Islamic Content tab")
            
            // Tab 2: AI Chat with Iman
            ImanChatView()
                .tabItem {
                    Label("Chat with Iman", systemImage: "message.fill")
                }
                .tag(1)
                .accessibilityLabel("Chat with Iman tab")
            
            // Tab 3: Settings
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(2)
                .accessibilityLabel("Settings tab")
        }
        .tint(Color(hex: "#66BB6A")) // Jasmine green accent
        .preferredColorScheme(appState.isDarkMode ? .dark : nil)
        .onChange(of: selectedTab) { oldValue, newValue in
            // Haptic feedback on tab change
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
    }
}

#Preview {
    HomeView()
        .environment(AppState())
}
