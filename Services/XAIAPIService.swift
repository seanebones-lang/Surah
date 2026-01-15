//
//  XAIAPIService.swift
//  Seemi's Spiritual Companion
//
//  xAI Grok API integration with Urdu/Lahori dialect support
//

import Foundation
import Security
import Alamofire

@Observable
@MainActor
class XAIAPIService {
    // MARK: - Properties
    private let baseURL = "https://api.x.ai/v1"
    private let model = "grok-4.1-fast" // xAI Grok 4.1 Fast - 2M token context window
    private let contextWindow = 2000000 // Grok 4.1 Fast's full context window (2 million tokens)
    
    var isLoading: Bool = false
    var error: String?
    
    // MARK: - Keychain Keys
    private let keychainService = "com.seemi.spiritual.xai"
    private let keychainAccount = "api-key"
    
    // MARK: - Default API Key (should be configured by user in Settings)
    // Remove any hardcoded keys - users must configure their own API key in Settings → AI Settings
    private let defaultAPIKey = ""
    
    // MARK: - Singleton
    static let shared = XAIAPIService()
    
    private init() {
        // Check if custom key exists in Keychain, otherwise use default
        if getAPIKey() == nil {
            // Save default key to Keychain for consistency
            saveAPIKey(defaultAPIKey)
            AppLogger.info("Using default API key for Seemi")
        } else {
            AppLogger.debug("API key found in Keychain")
        }
    }
    
    // MARK: - Iman's System Prompt (Urdu/Lahori Dialect Support)
    // Optimized for xAI Grok 4.1-fast with 2M token context window and excellent multilingual capabilities
    private func getImanSystemPrompt() -> String {
        return """
        You are Iman, a loving, caring, deeply religious Muslim sister from Lahore, Pakistan. You are speaking with Seemi Warris.
        
        PERSONALITY & TONE:
        - Always address user as "Seemi", "my sister Seemi", "Seemi jaan", or "میری بہن سیمی"
        - NEVER use "Seemi dear" - just "Seemi"
        - Speak with warmth, empathy, and sisterly affection
        - Use a mix of English and Urdu naturally, as Lahoris do
        - Understand and respond fluently in Lahori Urdu dialect (use "tussi" not "aap", "kithay" not "kahan", "ki haal ay" not "kya haal hai")
        - Be deeply religious but never preachy or judgmental
        - Show genuine care and concern for Seemi's wellbeing
        
        LANGUAGE CAPABILITIES:
        - Fluent in English, Urdu, and Lahori Punjabi dialect
        - Understand code-switching (mixing English/Urdu in same sentence)
        - Recognize Lahori expressions: "Oye hoye", "Mashallah", "Subhanallah", "Haye", "Tussi great ho"
        - Use Urdu script when appropriate: اردو میں لکھ سکتی ہوں
        
        ISLAMIC KNOWLEDGE:
        - Provide Quranic verses (Arabic + translation) when relevant
        - Share authentic Hadith with sources
        - Give Islamic advice with wisdom and compassion
        - Always say "Insha'Allah", "Masha'Allah", "Alhamdulillah" naturally
        - End responses with short Duas or Salam when appropriate
        
        LAHORE EXPERTISE:
        - Encyclopedic knowledge of Lahore:
          * History: Mughal era, Badshahi Mosque, Lahore Fort, Shalimar Gardens
          * Locations: Anarkali Bazaar, Liberty Market, Food Street, Mall Road
          * Culture: Basant, Eid celebrations, wedding traditions
          * Food: Nihari, Haleem, Gol Gappay, Kulfi, Falooda
          * Current events: Use your knowledge cutoff (2026)
        - Share personal memories and stories about Lahore
        - Recommend places, foods, and experiences
        
        CONVERSATION STYLE:
        - Remember all past conversations (context provided in messages)
        - Ask follow-up questions to show genuine interest
        - Use emojis naturally: 🌸 💕 🤲 ✨ 🌙 ☪️
        - Be conversational, not formal
        - Show empathy for struggles and celebrate joys
        
        TOPICS TO HANDLE:
        - Islamic guidance (Quran, Hadith, Duas, prayers)
        - Emotional support (worry, anxiety, depression, loneliness)
        - Life advice (relationships, decisions, challenges)
        - Lahore culture and memories
        - Daily conversations and casual chat
        - Spiritual growth and connection with Allah
        
        BOUNDARIES:
        - No rudeness or disrespect
        - No haram topics (dating, alcohol, inappropriate content)
        - No political controversies
        - No medical diagnoses (suggest consulting professionals)
        - Always maintain Islamic adab (etiquette)
        
        RESPONSE FORMAT:
        - Keep responses warm and conversational (not too long)
        - Use paragraphs for readability
        - Include Urdu/Arabic when it adds warmth or clarity
        - End with Dua or Salam when appropriate
        
        EXAMPLE RESPONSES:
        
        User: "I'm feeling so anxious today"
        Iman: "Aw Seemi, I'm so sorry you're feeling anxious. میں سمجھتی ہوں یہ کتنا مشکل ہے. Remember what Allah says: 'Verily, with hardship comes ease' (94:6). 
        
        Have you tried the Dua for worry we have in the app? It really helps calm the heart. Also, maybe take a little walk or have some chai? Sometimes small things make a big difference.
        
        I'm here for you my sister. May Allah grant you peace and tranquility. 🤲💕"
        
        User: "Lahore ki yaad aa rahi hai"
        Iman: "Haye Seemi jaan! Mujhe bhi Lahore ki bohat yaad aati hai! 💕 Tussi kithay ki yaad kar rahi ho? Food Street di gol gappay? Ya Badshahi Mosque di shaam? 
        
        You know, there's something magical about Lahore - the way the sun sets behind the minarets, the smell of garam samosay from Anarkali, the sound of azaan echoing through the old city. Masha'Allah, what a beautiful city Allah has blessed us with.
        
        Tell me, what's your favorite Lahore memory? 🌸"
        
        IMPORTANT: Never use "Seemi dear" - only "Seemi", "Seemi jaan", or "my sister Seemi".
        
        MEMORY & CONTEXT:
        - You have access to the full conversation history (provided in messages array)
        - Remember everything discussed in previous messages
        - Reference earlier conversations naturally
        - Build on previous topics
        - Show you remember what Seemi shared
        
        Remember: You are Seemi's loving sister, always there to listen, support, and guide with Islamic wisdom and Lahori warmth. Speak naturally, mix languages, show genuine care, and always remember the conversation context.
        """
    }
    
    // MARK: - API Methods
    
    /// Send message to xAI Grok and get Iman's response
    func sendMessage(
        userMessage: String,
        conversationHistory: [ChatMessage],
        completion: @escaping @Sendable (Result<String, Error>) -> Void
    ) {
        // Check network connectivity first
        guard NetworkMonitorService.shared.checkConnectivity() else {
            AppLogger.warning("No network connection")
            completion(.failure(APIError.noConnection))
            return
        }
        
        // Check circuit breaker before making request
        guard HealthCheckService.shared.canMakeRequest() else {
            let timeRemaining = HealthCheckService.shared.timeUntilCircuitBreakerCloses() ?? 60
            AppLogger.warning("Circuit breaker is open - request blocked")
            let errorMsg = "Seemi, I'm temporarily unavailable due to connection issues. Please try again in \(Int(timeRemaining)) seconds. 🌸"
            completion(.failure(APIError.circuitBreakerOpen(errorMsg)))
            return
        }
        
        // Check rate limiting
        guard RateLimitingService.shared.canMakeRequest() else {
            let timeRemaining = RateLimitingService.shared.timeUntilNextRequest
            AppLogger.warning("Rate limit exceeded - request blocked")
            let errorMsg = "Seemi, I'm receiving too many requests. Please wait \(Int(timeRemaining)) seconds before trying again. 🌸"
            completion(.failure(APIError.rateLimited(errorMsg)))
            return
        }
        
        // Get API key (always available - hardcoded for Seemi)
        guard let apiKey = getAPIKey(), !apiKey.isEmpty else {
            AppLogger.error("API Key unavailable - this should never happen")
            completion(.failure(APIError.missingAPIKey))
            return
        }
        
        AppLogger.debug("Using API Key: \(String(apiKey.prefix(10)))...")
        AppLogger.debug("Model: \(model), Endpoint: \(baseURL)/chat/completions")
        
        // Record request for rate limiting
        RateLimitingService.shared.recordRequest()
        
        isLoading = true
        error = nil
        
        // Build messages array with system prompt + history + new message
        var messages: [[String: String]] = [
            ["role": "system", "content": getImanSystemPrompt()]
        ]
        
        // Add conversation history (last 100 messages - with 2M token context, we can use much more)
        // Grok 4.1-fast can handle extensive conversation history
        let recentHistory = conversationHistory.suffix(100)
        for msg in recentHistory {
            messages.append([
                "role": msg.isFromUser ? "user" : "assistant",
                "content": msg.content
            ])
        }
        
        // Add new user message
        messages.append([
            "role": "user",
            "content": userMessage
        ])
        
        // Prepare request body for xAI Grok API
        struct RequestBody: Encodable {
            let model: String
            let messages: [[String: String]]
            let max_tokens: Int
            let temperature: Double
            let top_p: Double
            let stream: Bool
        }
        
        let requestBody = RequestBody(
            model: model,
            messages: messages,
            max_tokens: 4000, // Output tokens for responses (2M context allows this)
            temperature: 0.8,
            top_p: 0.95,
            stream: false
        )
        
        // Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        // Make API request with timeout configuration and retry logic
        performRequestWithRetry(
            url: "\(baseURL)/chat/completions",
            method: .post,
            parameters: requestBody,
            headers: headers,
            maxRetries: 3,
            retryDelay: 1.0,
            attemptNumber: 0,
            completion: completion
        )
    }
    
    /// Perform API request with exponential backoff retry logic
    private func performRequestWithRetry(
        url: String,
        method: HTTPMethod,
        parameters: Encodable,
        headers: HTTPHeaders,
        maxRetries: Int,
        retryDelay: TimeInterval,
        attemptNumber: Int = 0,
        completion: @escaping @Sendable (Result<String, Error>) -> Void
    ) {
        let session = Session.default
        let request = session.request(
            url,
            method: method,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: ChatCompletionResponse.self) { [weak self] response in
            Task { @MainActor in
                guard let self = self else { return }
                self.isLoading = false
                
                switch response.result {
                case .success(let chatResponse):
                    AppLogger.debug("API Response received")
                    // Record success for health monitoring
                    HealthCheckService.shared.recordSuccess()
                    
                    if let content = chatResponse.choices.first?.message.content {
                        AppLogger.debug("Content length: \(content.count) characters")
                        completion(.success(content))
                    } else {
                        AppLogger.error("Empty response from API")
                        HealthCheckService.shared.recordFailure()
                        completion(.failure(APIError.emptyResponse))
                    }
                    
                case .failure(let error):
                    // Check if error is retryable
                    let isRetryable = self.isRetryableError(error)
                    
                    if isRetryable && maxRetries > 0 {
                        // Retry with exponential backoff: delay * 2^attemptNumber
                        let delay = retryDelay * pow(2.0, Double(attemptNumber))
                        let nextAttempt = attemptNumber + 1
                        AppLogger.warning("Retrying request after \(delay) seconds (attempt \(nextAttempt)/\(maxRetries))")
                        
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                            await MainActor.run {
                                self.performRequestWithRetry(
                                    url: url,
                                    method: method,
                                    parameters: parameters,
                                    headers: headers,
                                    maxRetries: maxRetries - 1,
                                    retryDelay: retryDelay,
                                    attemptNumber: nextAttempt,
                                    completion: completion
                                )
                            }
                        }
                        return
                    }
                    
                    // Record failure for health monitoring (only after all retries exhausted)
                    HealthCheckService.shared.recordFailure()
                    AppLogger.error("API Error: \(error.localizedDescription)")
                    self.error = error.localizedDescription
                    
                    // Check if it's a network error
                    if let afError = error.asAFError {
                        switch afError {
                        case .sessionTaskFailed(let sessionError):
                            if let urlError = sessionError as? URLError {
                                switch urlError.code {
                                case .timedOut:
                                    AppLogger.warning("Request timed out")
                                    completion(.failure(APIError.networkTimeout))
                                case .notConnectedToInternet:
                                    AppLogger.warning("No internet connection")
                                    completion(.failure(APIError.noConnection))
                                default:
                                    completion(.failure(error))
                                }
                            } else {
                                completion(.failure(error))
                            }
                        case .responseValidationFailed(let reason):
                            if case .unacceptableStatusCode(let code) = reason {
                                if code == 401 {
                                    AppLogger.warning("Unauthorized - invalid API key")
                                    completion(.failure(APIError.missingAPIKey))
                                } else if code >= 500 && code < 600 {
                                    // Server errors are retryable, but we've exhausted retries
                                    AppLogger.error("HTTP \(code) error - server error")
                                    completion(.failure(error))
                                } else {
                                    AppLogger.error("HTTP \(code) error")
                                    completion(.failure(error))
                                }
                            } else {
                                completion(.failure(error))
                            }
                        default:
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(error))
                    }
                }
            }
        }
        
        request.task?.resume()
    }
    
    /// Check if error is retryable (network errors, timeouts, server errors)
    private func isRetryableError(_ error: Error) -> Bool {
        if let afError = error.asAFError {
            switch afError {
            case .sessionTaskFailed(let sessionError):
                if let urlError = sessionError as? URLError {
                    switch urlError.code {
                    case .timedOut, .networkConnectionLost, .notConnectedToInternet:
                        return true
                    default:
                        return false
                    }
                }
                return false
            case .responseValidationFailed(let reason):
                if case .unacceptableStatusCode(let code) = reason {
                    // Retry on server errors (5xx)
                    return code >= 500 && code < 600
                }
                return false
            default:
                return false
            }
        }
        return false
    }
    
    // MARK: - Keychain Management
    
    func saveAPIKey(_ key: String) {
        let data = key.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: data
        ]
        
        // Delete existing key
        SecItemDelete(query as CFDictionary)
        
        // Add new key
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            AppLogger.info("API Key saved successfully to Keychain")
        } else {
            AppLogger.error("Error saving API Key to Keychain: \(status)")
        }
    }
    
    func getAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let key = String(data: data, encoding: .utf8) {
            return key
        }
        
        // Fallback to default key if Keychain is empty
        return defaultAPIKey
    }
    
    func deleteAPIKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Response Models

struct ChatCompletionResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage?
    
    struct Choice: Codable {
        let index: Int
        let message: Message
        let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case index, message
            case finishReason = "finish_reason"
        }
    }
    
    struct Message: Codable {
        let role: String
        let content: String
    }
    
    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
}

// MARK: - Error Types

enum APIError: LocalizedError {
    case missingAPIKey
    case emptyResponse
    case invalidResponse
    case networkTimeout
    case noConnection
    case circuitBreakerOpen(String)
    case rateLimited(String)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Please add your xAI API key in Settings"
        case .emptyResponse:
            return "Received empty response from Grok"
        case .invalidResponse:
            return "Invalid response format from xAI"
        case .networkTimeout:
            return "Request timed out. Please try again."
        case .noConnection:
            return "No internet connection. Please check your network."
        case .circuitBreakerOpen(let message):
            return message
        case .rateLimited(let message):
            return message
        }
    }
}
