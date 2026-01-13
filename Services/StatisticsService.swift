//
//  StatisticsService.swift
//  Seemi's Spiritual Companion
//
//  Usage statistics and Islamic calendar
//

import Foundation
import SwiftData

@Observable
@MainActor
class StatisticsService {
    // MARK: - Properties
    var prayersCompleted: Int = 0
    var duasRecited: Int = 0
    var chatMessagesSent: Int = 0
    var totalTimeSpent: TimeInterval = 0
    var currentHijriDate: String = ""
    var islamicEvents: [IslamicEvent] = []
    
    private var sessionStartTime: Date?
    
    // MARK: - Singleton
    static let shared = StatisticsService()
    
    private init() {
        loadStatistics()
        updateHijriDate()
        loadIslamicEvents()
    }
    
    // MARK: - Statistics Tracking
    
    func incrementPrayersCompleted() {
        prayersCompleted += 1
        saveStatistics()
    }
    
    func incrementDuasRecited() {
        duasRecited += 1
        saveStatistics()
    }
    
    func incrementChatMessages() {
        chatMessagesSent += 1
        saveStatistics()
    }
    
    func startSession() {
        sessionStartTime = Date()
    }
    
    func endSession() {
        guard let startTime = sessionStartTime else { return }
        let sessionDuration = Date().timeIntervalSince(startTime)
        totalTimeSpent += sessionDuration
        sessionStartTime = nil
        saveStatistics()
    }
    
    // MARK: - Persistence
    
    private func saveStatistics() {
        UserDefaults.standard.set(prayersCompleted, forKey: "prayersCompleted")
        UserDefaults.standard.set(duasRecited, forKey: "duasRecited")
        UserDefaults.standard.set(chatMessagesSent, forKey: "chatMessagesSent")
        UserDefaults.standard.set(totalTimeSpent, forKey: "totalTimeSpent")
    }
    
    private func loadStatistics() {
        prayersCompleted = UserDefaults.standard.integer(forKey: "prayersCompleted")
        duasRecited = UserDefaults.standard.integer(forKey: "duasRecited")
        chatMessagesSent = UserDefaults.standard.integer(forKey: "chatMessagesSent")
        totalTimeSpent = UserDefaults.standard.double(forKey: "totalTimeSpent")
    }
    
    func resetStatistics() {
        prayersCompleted = 0
        duasRecited = 0
        chatMessagesSent = 0
        totalTimeSpent = 0
        saveStatistics()
    }
    
    // MARK: - Islamic Calendar (Hijri)
    
    func updateHijriDate() {
        let calendar = Calendar(identifier: .islamicUmmAlQura)
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        
        if let year = components.year,
           let month = components.month,
           let day = components.day {
            let monthName = hijriMonthName(month)
            currentHijriDate = "\(day) \(monthName) \(year) AH"
        }
    }
    
    private func hijriMonthName(_ month: Int) -> String {
        let months = [
            "Muharram", "Safar", "Rabi' al-Awwal", "Rabi' al-Thani",
            "Jumada al-Awwal", "Jumada al-Thani", "Rajab", "Sha'ban",
            "Ramadan", "Shawwal", "Dhul-Qi'dah", "Dhul-Hijjah"
        ]
        return months[month - 1]
    }
    
    // MARK: - Islamic Events
    
    private func loadIslamicEvents() {
        // Get current Hijri year
        let calendar = Calendar(identifier: .islamicUmmAlQura)
        let year = calendar.component(.year, from: Date())
        
        islamicEvents = [
            IslamicEvent(
                name: "Islamic New Year",
                hijriDate: "1 Muharram \(year)",
                description: "Beginning of the Islamic year"
            ),
            IslamicEvent(
                name: "Day of Ashura",
                hijriDate: "10 Muharram \(year)",
                description: "Day of fasting and remembrance"
            ),
            IslamicEvent(
                name: "Mawlid al-Nabi",
                hijriDate: "12 Rabi' al-Awwal \(year)",
                description: "Birth of Prophet Muhammad ﷺ"
            ),
            IslamicEvent(
                name: "Isra and Mi'raj",
                hijriDate: "27 Rajab \(year)",
                description: "Night Journey and Ascension"
            ),
            IslamicEvent(
                name: "Laylat al-Bara'ah",
                hijriDate: "15 Sha'ban \(year)",
                description: "Night of Forgiveness"
            ),
            IslamicEvent(
                name: "Ramadan Begins",
                hijriDate: "1 Ramadan \(year)",
                description: "Month of fasting"
            ),
            IslamicEvent(
                name: "Laylat al-Qadr",
                hijriDate: "27 Ramadan \(year)",
                description: "Night of Power"
            ),
            IslamicEvent(
                name: "Eid al-Fitr",
                hijriDate: "1 Shawwal \(year)",
                description: "Festival of Breaking the Fast"
            ),
            IslamicEvent(
                name: "Day of Arafah",
                hijriDate: "9 Dhul-Hijjah \(year)",
                description: "Day of Hajj"
            ),
            IslamicEvent(
                name: "Eid al-Adha",
                hijriDate: "10 Dhul-Hijjah \(year)",
                description: "Festival of Sacrifice"
            )
        ]
    }
    
    func getUpcomingEvents(count: Int = 3) -> [IslamicEvent] {
        // Return next few events (simplified - would need proper date comparison)
        return Array(islamicEvents.prefix(count))
    }
}

// MARK: - Models

struct IslamicEvent: Identifiable {
    let id = UUID()
    let name: String
    let hijriDate: String
    let description: String
}

struct UsageStatistics {
    let prayersCompleted: Int
    let duasRecited: Int
    let chatMessagesSent: Int
    let totalTimeSpent: TimeInterval
    
    var formattedTimeSpent: String {
        let hours = Int(totalTimeSpent) / 3600
        let minutes = (Int(totalTimeSpent) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
