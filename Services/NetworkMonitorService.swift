//
//  NetworkMonitorService.swift
//  Seemi's Spiritual Companion
//
//  Network connectivity monitoring for offline detection
//

import Foundation
import Network

/// Service for monitoring network connectivity and detecting offline state
@Observable
@MainActor
final class NetworkMonitorService {
    
    // MARK: - Properties
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.seemi.spiritual.networkMonitor")
    
    var isConnected: Bool = true
    var connectionType: ConnectionType = .unknown
    var isExpensive: Bool = false
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    // MARK: - Singleton
    
    static let shared = NetworkMonitorService()
    
    private init() {
        startMonitoring()
    }
    
    // MARK: - Monitoring
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                
                self.isConnected = path.status == .satisfied
                self.isExpensive = path.isExpensive
                
                if path.usesInterfaceType(.wifi) {
                    self.connectionType = .wifi
                } else if path.usesInterfaceType(.cellular) {
                    self.connectionType = .cellular
                } else if path.usesInterfaceType(.wiredEthernet) {
                    self.connectionType = .ethernet
                } else {
                    self.connectionType = .unknown
                }
                
                if self.isConnected {
                    AppLogger.info("Network connected: \(self.connectionType)")
                } else {
                    AppLogger.warning("Network disconnected")
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    /// Check if network is available (synchronous check)
    func checkConnectivity() -> Bool {
        return isConnected
    }
    
    /// Stop monitoring (call before deinit)
    func stopMonitoring() {
        monitor.cancel()
    }
    
    deinit {
        stopMonitoring()
    }
}
