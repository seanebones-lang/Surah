//
//  RateLimitingService.swift
//  Seemi's Spiritual Companion
//
//  Client-side rate limiting to prevent API quota exhaustion
//

import Foundation

/// Service for managing API request rate limiting
@Observable
@MainActor
final class RateLimitingService {
    
    // MARK: - Properties
    
    /// Maximum requests per minute
    private let maxRequestsPerMinute: Int = 10
    
    /// Maximum requests per hour
    private let maxRequestsPerHour: Int = 100
    
    /// Request timestamps (for rate limiting)
    private var requestTimestamps: [Date] = []
    
    /// Queue for requests that exceed rate limit
    private var queuedRequests: [() -> Void] = []
    
    var isRateLimited: Bool = false
    var timeUntilNextRequest: TimeInterval = 0
    
    // MARK: - Singleton
    
    static let shared = RateLimitingService()
    
    private init() {
        // Load request history from UserDefaults
        loadRequestHistory()
    }
    
    // MARK: - Rate Limiting
    
    /// Check if request is allowed (not rate limited)
    func canMakeRequest() -> Bool {
        cleanupOldRequests()
        
        // Check per-minute limit
        let recentRequests = requestTimestamps.filter { 
            Date().timeIntervalSince($0) < 60 
        }
        
        if recentRequests.count >= maxRequestsPerMinute {
            isRateLimited = true
            if let oldestRequest = recentRequests.min() {
                timeUntilNextRequest = 60 - Date().timeIntervalSince(oldestRequest)
            }
            return false
        }
        
        // Check per-hour limit
        let hourlyRequests = requestTimestamps.filter { 
            Date().timeIntervalSince($0) < 3600 
        }
        
        if hourlyRequests.count >= maxRequestsPerHour {
            isRateLimited = true
            if let oldestRequest = hourlyRequests.min() {
                timeUntilNextRequest = 3600 - Date().timeIntervalSince(oldestRequest)
            }
            return false
        }
        
        isRateLimited = false
        return true
    }
    
    /// Record a request timestamp
    func recordRequest() {
        let now = Date()
        requestTimestamps.append(now)
        
        // Persist to UserDefaults (keep last 100 timestamps)
        saveRequestHistory()
        
        // Cleanup old requests
        cleanupOldRequests()
    }
    
    /// Queue a request to be executed when rate limit allows
    func queueRequest(_ request: @escaping () -> Void) {
        queuedRequests.append(request)
        processQueue()
    }
    
    /// Process queued requests when rate limit allows
    private func processQueue() {
        guard !queuedRequests.isEmpty else { return }
        
        if canMakeRequest() {
            let request = queuedRequests.removeFirst()
            recordRequest()
            request()
            
            // Process next request after delay
            Task {
                try? await Task.sleep(nanoseconds: 6_000_000_000) // 6 seconds between requests
                await MainActor.run {
                    processQueue()
                }
            }
        } else {
            // Schedule retry
            Task {
                try? await Task.sleep(nanoseconds: UInt64(timeUntilNextRequest * 1_000_000_000))
                await MainActor.run {
                    processQueue()
                }
            }
        }
    }
    
    // MARK: - Cleanup
    
    private func cleanupOldRequests() {
        // Remove requests older than 1 hour
        let oneHourAgo = Date().addingTimeInterval(-3600)
        requestTimestamps = requestTimestamps.filter { $0 > oneHourAgo }
    }
    
    // MARK: - Persistence
    
    private func saveRequestHistory() {
        // Keep only last 100 timestamps
        let recentTimestamps = Array(requestTimestamps.suffix(100))
        let timestampsData = recentTimestamps.map { $0.timeIntervalSince1970 }
        UserDefaults.standard.set(timestampsData, forKey: "com.seemi.spiritual.rateLimitHistory")
    }
    
    private func loadRequestHistory() {
        guard let timestampsData = UserDefaults.standard.array(forKey: "com.seemi.spiritual.rateLimitHistory") as? [TimeInterval] else {
            return
        }
        
        requestTimestamps = timestampsData.map { Date(timeIntervalSince1970: $0) }
        cleanupOldRequests()
    }
    
    /// Reset rate limit (for testing or manual override)
    func reset() {
        requestTimestamps.removeAll()
        queuedRequests.removeAll()
        isRateLimited = false
        timeUntilNextRequest = 0
        UserDefaults.standard.removeObject(forKey: "com.seemi.spiritual.rateLimitHistory")
    }
}
