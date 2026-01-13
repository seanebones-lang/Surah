//
//  NotificationService.swift
//  Seemi's Spiritual Companion
//
//  Prayer time notifications and daily Dua reminders
//

import Foundation
import UserNotifications
import CoreLocation

@Observable
@MainActor
class NotificationService: NSObject {
    // MARK: - Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private let locationManager = CLLocationManager()
    
    var isAuthorized: Bool = false
    var prayerTimes: PrayerTimes?
    var nextPrayer: Prayer?
    var currentLocation: CLLocationCoordinate2D?
    var locationName: String = "Fetching location..."
    
    // Lahore coordinates (fallback if location unavailable)
    private let lahoreCoordinates = CLLocationCoordinate2D(
        latitude: 31.5204,
        longitude: 74.3587
    )
    
    // MARK: - Singleton
    static let shared = NotificationService()
    
    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    // MARK: - Location
    
    /// Check current location authorization status
    func checkLocationAuthorization() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    /// Request location permission and fetch location
    func requestLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            // Request permission first
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // Already authorized, request location
            locationManager.requestLocation()
        case .denied, .restricted:
            // Permission denied, use Lahore fallback
            print("⚠️ Location permission denied, using Lahore coordinates")
            Task { @MainActor in
                self.locationName = "Lahore, Pakistan (default)"
                // Still fetch prayer times with Lahore coordinates
                self.fetchPrayerTimes { _ in }
            }
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// Request location on app launch (called automatically)
    func requestLocationOnLaunch() {
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            // First time - request permission
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Already authorized - get location immediately
            locationManager.requestLocation()
            // Fetch prayer times
            fetchPrayerTimes { _ in }
        } else {
            // Permission denied - use Lahore fallback
            Task { @MainActor in
                self.locationName = "Lahore, Pakistan (default)"
                self.fetchPrayerTimes { _ in }
            }
        }
    }
    
    func getCurrentCoordinates() -> CLLocationCoordinate2D {
        // Use actual location if available, otherwise fallback to Lahore
        return currentLocation ?? lahoreCoordinates
    }
    
    // MARK: - Authorization
    
    func requestAuthorization(completion: @escaping @Sendable (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            Task { @MainActor in
                self.isAuthorized = granted
                completion(granted)
            }
        }
    }
    
    // MARK: - Prayer Times
    
    /// Fetch prayer times based on current location (or Lahore as fallback)
    func fetchPrayerTimes(completion: @escaping @Sendable (Result<PrayerTimes, Error>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: Date())
        
        // Use current location or fallback to Lahore
        let coordinates = getCurrentCoordinates()
        
        // Aladhan API with actual location
        let urlString = "https://api.aladhan.com/v1/timings/\(dateString)?latitude=\(coordinates.latitude)&longitude=\(coordinates.longitude)&method=2"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NotificationError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NotificationError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(AladhanResponse.self, from: data)
                
                Task { @MainActor in
                    let prayerTimes = PrayerTimes(
                        fajr: self.parseTime(result.data.timings.Fajr),
                        dhuhr: self.parseTime(result.data.timings.Dhuhr),
                        asr: self.parseTime(result.data.timings.Asr),
                        maghrib: self.parseTime(result.data.timings.Maghrib),
                        isha: self.parseTime(result.data.timings.Isha),
                        date: Date()
                    )
                    
                    self.prayerTimes = prayerTimes
                    completion(.success(prayerTimes))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Schedule prayer time notifications
    func schedulePrayerNotifications() {
        guard let prayerTimes = prayerTimes else {
            fetchPrayerTimes { result in
                Task { @MainActor in
                    if case .success = result {
                        self.schedulePrayerNotifications()
                    }
                }
            }
            return
        }
        
        // Remove existing prayer notifications
        notificationCenter.removePendingNotificationRequests(withIdentifiers: Prayer.allCases.map { $0.rawValue })
        
        // Schedule each prayer
        for prayer in Prayer.allCases {
            let time = prayerTimes.time(for: prayer)
            schedulePrayerNotification(prayer: prayer, time: time)
        }
    }
    
    private func schedulePrayerNotification(prayer: Prayer, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Prayer Time - \(prayer.displayName)"
        content.body = "It's time for \(prayer.displayName) prayer, Seemi dear. 🤲"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("prayer_\(prayer.rawValue).mp3"))
        content.categoryIdentifier = "PRAYER_NOTIFICATION"
        
        // Add Arabic text
        content.subtitle = prayer.arabicName
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: prayer.rawValue,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling \(prayer.displayName): \(error)")
            }
        }
    }
    
    // MARK: - Daily Dua Reminders
    
    func scheduleDuaReminders() {
        // Remove existing dua reminders
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["dua_morning", "dua_noon", "dua_evening"])
        
        // Morning Dua (8 AM PKT) - Item #2: Protection Dua
        scheduleDuaReminder(
            identifier: "dua_morning",
            hour: 8,
            minute: 0,
            title: "Morning Dua Reminder 🌅",
            body: "Recite the morning protection Dua 3 times, Seemi dear.",
            duaIndex: 1
        )
        
        // Noon Dua (2 PM PKT) - Item #1: Remove Worry
        scheduleDuaReminder(
            identifier: "dua_noon",
            hour: 14,
            minute: 0,
            title: "Afternoon Dua Reminder ☀️",
            body: "Take a moment to recite the Dua to remove worry.",
            duaIndex: 0
        )
        
        // Evening Dua (8 PM PKT) - Item #6: Healing
        scheduleDuaReminder(
            identifier: "dua_evening",
            hour: 20,
            minute: 0,
            title: "Evening Dua Reminder 🌙",
            body: "Recite the healing Dua before sleep, Seemi dear.",
            duaIndex: 5
        )
    }
    
    private func scheduleDuaReminder(identifier: String, hour: Int, minute: Int, title: String, body: String, duaIndex: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "DUA_REMINDER"
        content.userInfo = ["duaIndex": duaIndex]
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.timeZone = TimeZone(identifier: "Asia/Karachi")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling dua reminder: \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func parseTime(_ timeString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Karachi")
        
        let calendar = Calendar.current
        let now = Date()
        
        if let time = formatter.date(from: timeString) {
            let components = calendar.dateComponents([.hour, .minute], from: time)
            return calendar.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: 0, of: now) ?? now
        }
        
        return now
    }
    
    func updateNextPrayer() {
        guard let prayerTimes = prayerTimes else { return }
        
        let now = Date()
        for prayer in Prayer.allCases {
            let time = prayerTimes.time(for: prayer)
            if time > now {
                nextPrayer = prayer
                return
            }
        }
        
        // If all prayers passed, next is Fajr tomorrow
        nextPrayer = .fajr
    }
}

// MARK: - CLLocationManagerDelegate

extension NotificationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        Task { @MainActor in
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                // Permission granted - request location
                self.locationManager.requestLocation()
            case .denied, .restricted:
                // Permission denied - use Lahore fallback
                print("⚠️ Location permission denied, using Lahore coordinates")
                self.locationName = "Lahore, Pakistan (default)"
                self.fetchPrayerTimes { _ in }
            case .notDetermined:
                // Still waiting for user response
                break
            @unknown default:
                break
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task { @MainActor in
            self.currentLocation = location.coordinate
            
            // Get location name (reverse geocoding)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first {
                    let city = placemark.locality ?? "Unknown"
                    let country = placemark.country ?? ""
                    Task { @MainActor in
                        self.locationName = "\(city), \(country)"
                    }
                } else if let error = error {
                    print("⚠️ Reverse geocoding error: \(error.localizedDescription)")
                    Task { @MainActor in
                        self.locationName = "Location: \(String(format: "%.2f", location.coordinate.latitude)), \(String(format: "%.2f", location.coordinate.longitude))"
                    }
                }
            }
            
            // Fetch prayer times for new location
            self.fetchPrayerTimes { _ in }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Location error: \(error.localizedDescription)")
        Task { @MainActor in
            // Use Lahore fallback on error
            self.locationName = "Lahore, Pakistan (default)"
            // Still fetch prayer times with Lahore coordinates
            self.fetchPrayerTimes { _ in }
        }
    }
}

// MARK: - Models

struct PrayerTimes {
    let fajr: Date
    let dhuhr: Date
    let asr: Date
    let maghrib: Date
    let isha: Date
    let date: Date
    
    func time(for prayer: Prayer) -> Date {
        switch prayer {
        case .fajr: return fajr
        case .dhuhr: return dhuhr
        case .asr: return asr
        case .maghrib: return maghrib
        case .isha: return isha
        }
    }
}

enum Prayer: String, CaseIterable {
    case fajr = "fajr"
    case dhuhr = "dhuhr"
    case asr = "asr"
    case maghrib = "maghrib"
    case isha = "isha"
    
    var displayName: String {
        switch self {
        case .fajr: return "Fajr"
        case .dhuhr: return "Dhuhr"
        case .asr: return "Asr"
        case .maghrib: return "Maghrib"
        case .isha: return "Isha"
        }
    }
    
    var arabicName: String {
        switch self {
        case .fajr: return "صلاة الفجر"
        case .dhuhr: return "صلاة الظهر"
        case .asr: return "صلاة العصر"
        case .maghrib: return "صلاة المغرب"
        case .isha: return "صلاة العشاء"
        }
    }
}

// MARK: - Aladhan API Response

struct AladhanResponse: Codable {
    let data: AladhanData
}

struct AladhanData: Codable {
    let timings: AladhanTimings
}

struct AladhanTimings: Codable {
    let Fajr: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

// MARK: - Errors

enum NotificationError: LocalizedError {
    case invalidURL
    case noData
    case notAuthorized
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid prayer times URL"
        case .noData:
            return "No data received from prayer times API"
        case .notAuthorized:
            return "Notifications not authorized"
        }
    }
}
