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
            // Better error handling - log and create in-memory fallback
            AppLogger.error("Failed to create ModelContainer: \(error.localizedDescription)")
            AppLogger.warning("Using in-memory storage as fallback")
            let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                return try ModelContainer(for: schema, configurations: [fallbackConfig])
            } catch {
                AppLogger.error("Could not create ModelContainer even with fallback: \(error.localizedDescription)")
                // Return in-memory container as last resort - app will function but data won't persist
                // This is better than crashing the app
                if let lastResort = try? ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)]) {
                    return lastResort
                }
                // Only fatal if we absolutely cannot create any container
                fatalError("Critical: Unable to initialize data storage. Please reinstall the app.")
            }
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            if appState.showLaunchScreen {
                LaunchScreenView()
                    .environment(appState)
                    .onAppear {
                        // Initialize services on app launch
                        _ = XAIAPIService.shared
                        _ = NetworkMonitorService.shared // Start network monitoring
                        _ = HealthCheckService.shared // Initialize health check
                        _ = RateLimitingService.shared // Initialize rate limiting
                        // Request location permission on app launch for prayer times
                        NotificationService.shared.requestLocationOnLaunch()
                    }
            } else {
                HomeView()
                    .environment(appState)
                    .onAppear {
                        // Initialize services if not already done
                        _ = XAIAPIService.shared
                        _ = NetworkMonitorService.shared // Ensure network monitoring is active
                        // Ensure location is requested when home view appears
                        if NotificationService.shared.checkLocationAuthorization() == .notDetermined {
                            NotificationService.shared.requestLocationOnLaunch()
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                        // Optimize battery: Clean up resources when app goes to background
                        AudioPlayerService.shared.pause() // Pause audio to save battery
                        SpeechService.shared.cleanup() // Clean up speech resources
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        // Reinitialize network monitoring when app comes to foreground
                        _ = NetworkMonitorService.shared
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
    var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        }
    }
    var prayerTimeZone: String = "Asia/Karachi" // Lahore PKT
    
    init() {
        // Load persisted preferences
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }
    
    func dismissLaunchScreen() {
        withAnimation(.easeOut(duration: 0.5)) {
            showLaunchScreen = false
        }
    }
}
