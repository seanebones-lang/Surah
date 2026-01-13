//
//  SeemiSpiritualCompanionApp.swift
//  Seemi's Spiritual Companion
//
//  Main application entry point
//

import SwiftUI
import SwiftData

@main
struct SeemiSpiritualCompanionApp: App {
    @State private var appState = AppState()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ChatMessage.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            if appState.showLaunchScreen {
                LaunchScreenView()
                    .environment(appState)
                    .onAppear {
                        // Initialize API key on app launch
                        _ = NextElevenAPIService.shared
                        // Request location permission on app launch for prayer times
                        NotificationService.shared.requestLocationOnLaunch()
                    }
            } else {
                HomeView()
                    .environment(appState)
                    .onAppear {
                        // Initialize API key if not already done
                        _ = NextElevenAPIService.shared
                        // Ensure location is requested when home view appears
                        if NotificationService.shared.checkLocationAuthorization() == .notDetermined {
                            NotificationService.shared.requestLocationOnLaunch()
                        }
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

// MARK: - App State
@Observable
class AppState {
    var showLaunchScreen: Bool = true
    var selectedTab: Int = 0
    var isDarkMode: Bool = false
    var notificationsEnabled: Bool = true
    var prayerTimeZone: String = "Asia/Karachi" // Lahore PKT
    
    func dismissLaunchScreen() {
        withAnimation(.easeOut(duration: 0.5)) {
            showLaunchScreen = false
        }
    }
}
