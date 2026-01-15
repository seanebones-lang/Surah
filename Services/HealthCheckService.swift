//
//  HealthCheckService.swift
//  Seemi's Spiritual Companion
//
//  Health monitoring and circuit breaker pattern for reliability
//

import Foundation

/// Service for monitoring API health and implementing circuit breaker pattern
@Observable
@MainActor
final class HealthCheckService {
    
    // MARK: - Properties
    
    enum HealthStatus {
        case healthy
        case degraded
        case unhealthy
    }
    
    var status: HealthStatus = .healthy
    var lastHealthCheck: Date?
    var consecutiveFailures: Int = 0
    var circuitBreakerOpen: Bool = false
    var circuitBreakerOpenedAt: Date?
    
    // MARK: - Configuration
    
    private let maxConsecutiveFailures = 5
    private let circuitBreakerTimeout: TimeInterval = 60 // 1 minute
    private let healthCheckInterval: TimeInterval = 300 // 5 minutes
    
    // MARK: - Singleton
    
    static let shared = HealthCheckService()
    
    private init() {
        loadState()
    }
    
    // MARK: - Health Monitoring
    
    /// Record a successful API call
    func recordSuccess() {
        consecutiveFailures = 0
        
        if circuitBreakerOpen {
            // Close circuit breaker on success
            circuitBreakerOpen = false
            circuitBreakerOpenedAt = nil
            status = .healthy
            AppLogger.info("Circuit breaker closed - service recovered")
        } else if status != .healthy {
            status = .healthy
        }
        
        lastHealthCheck = Date()
        saveState()
    }
    
    /// Record a failed API call
    func recordFailure() {
        consecutiveFailures += 1
        lastHealthCheck = Date()
        
        if consecutiveFailures >= maxConsecutiveFailures {
            // Open circuit breaker
            if !circuitBreakerOpen {
                circuitBreakerOpen = true
                circuitBreakerOpenedAt = Date()
                status = .unhealthy
                AppLogger.warning("Circuit breaker opened - \(consecutiveFailures) consecutive failures")
            }
        } else if consecutiveFailures >= 3 {
            status = .degraded
        }
        
        saveState()
    }
    
    /// Check if requests should be allowed (circuit breaker closed)
    func canMakeRequest() -> Bool {
        guard circuitBreakerOpen else {
            return true
        }
        
        // Check if circuit breaker timeout has elapsed
        if let openedAt = circuitBreakerOpenedAt {
            let elapsed = Date().timeIntervalSince(openedAt)
            if elapsed >= circuitBreakerTimeout {
                // Half-open state - allow one request to test recovery
                AppLogger.info("Circuit breaker entering half-open state")
                return true
            }
        }
        
        return false
    }
    
    /// Get time until circuit breaker allows requests again
    func timeUntilCircuitBreakerCloses() -> TimeInterval? {
        guard circuitBreakerOpen, let openedAt = circuitBreakerOpenedAt else {
            return nil
        }
        
        let elapsed = Date().timeIntervalSince(openedAt)
        let remaining = circuitBreakerTimeout - elapsed
        return remaining > 0 ? remaining : 0
    }
    
    // MARK: - State Persistence
    
    private func saveState() {
        UserDefaults.standard.set(consecutiveFailures, forKey: "com.seemi.spiritual.healthCheck.failures")
        UserDefaults.standard.set(circuitBreakerOpen, forKey: "com.seemi.spiritual.healthCheck.circuitOpen")
        if let openedAt = circuitBreakerOpenedAt {
            UserDefaults.standard.set(openedAt.timeIntervalSince1970, forKey: "com.seemi.spiritual.healthCheck.openedAt")
        }
    }
    
    private func loadState() {
        consecutiveFailures = UserDefaults.standard.integer(forKey: "com.seemi.spiritual.healthCheck.failures")
        circuitBreakerOpen = UserDefaults.standard.bool(forKey: "com.seemi.spiritual.healthCheck.circuitOpen")
        
        if let openedAtInterval = UserDefaults.standard.object(forKey: "com.seemi.spiritual.healthCheck.openedAt") as? TimeInterval {
            circuitBreakerOpenedAt = Date(timeIntervalSince1970: openedAtInterval)
            
            // Check if timeout has elapsed
            if let openedAt = circuitBreakerOpenedAt {
                let elapsed = Date().timeIntervalSince(openedAt)
                if elapsed >= circuitBreakerTimeout {
                    // Reset on app restart if timeout elapsed
                    circuitBreakerOpen = false
                    circuitBreakerOpenedAt = nil
                    consecutiveFailures = 0
                }
            }
        }
        
        // Update status based on failures
        if circuitBreakerOpen {
            status = .unhealthy
        } else if consecutiveFailures >= 3 {
            status = .degraded
        } else {
            status = .healthy
        }
    }
    
    /// Reset health check (for testing or manual recovery)
    func reset() {
        consecutiveFailures = 0
        circuitBreakerOpen = false
        circuitBreakerOpenedAt = nil
        status = .healthy
        lastHealthCheck = nil
        
        UserDefaults.standard.removeObject(forKey: "com.seemi.spiritual.healthCheck.failures")
        UserDefaults.standard.removeObject(forKey: "com.seemi.spiritual.healthCheck.circuitOpen")
        UserDefaults.standard.removeObject(forKey: "com.seemi.spiritual.healthCheck.openedAt")
    }
}
