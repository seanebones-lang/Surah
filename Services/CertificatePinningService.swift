//
//  CertificatePinningService.swift
//  Seemi's Spiritual Companion
//
//  SSL certificate pinning configuration for enhanced security
//  Uses Alamofire's ServerTrustManager for certificate validation
//

import Foundation
import Alamofire

/// Service for configuring SSL certificate pinning
final class CertificatePinningService {
    
    // MARK: - Certificate Pinning Configuration
    // NOTE: Certificate pinning is currently configured for development
    // In production, replace placeholder with actual certificate public key hashes
    // To get certificate hash: 
    // openssl s_client -connect api.x.ai:443 -showcerts | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256
    
    /// Create ServerTrustManager for Alamofire with certificate pinning
    static func createServerTrustManager() -> ServerTrustManager {
        // Define hosts that require certificate pinning
        let evaluators: [String: ServerTrustEvaluating] = [
            // xAI API - using default evaluation for now
            // TODO: Implement proper certificate pinning once certificates are obtained
            "api.x.ai": PublicKeysTrustEvaluator(),
            
            // Aladhan API
            "api.aladhan.com": PublicKeysTrustEvaluator(),
            
            // Quran Audio
            "download.quranicaudio.com": PublicKeysTrustEvaluator()
        ]
        
        // For all other hosts, use default evaluation (trust system certificates)
        return ServerTrustManager(evaluators: evaluators)
    }
    
    /// Check if certificate pinning is enabled
    static var isPinningEnabled: Bool {
        // Enable pinning in production builds only
        #if DEBUG
        // In debug, allow connections but log warnings
        return false
        #else
        return true
        #endif
    }
}
