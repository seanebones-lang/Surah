//
//  Logger.swift
//  Seemi's Spiritual Companion
//
//  Production-safe logging utility
//

import Foundation
import OSLog

extension Logger {
    static let app = Logger(subsystem: "com.seemi.spiritual", category: "App")
}

// Backward compatibility alias
enum AppLogger {
    #if DEBUG
    private static let isDebugMode = true
    #else
    private static let isDebugMode = false
    #endif
    
    static func debug(_ message: String) {
        guard isDebugMode else { return }
        Logger.app.debug("\(message)")
    }
    
    static func info(_ message: String) {
        Logger.app.info("\(message)")
    }
    
    static func warning(_ message: String) {
        Logger.app.warning("\(message)")
    }
    
    static func error(_ message: String) {
        Logger.app.error("\(message)")
    }
}
