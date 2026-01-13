//
//  NextElevenAPIService.swift
//  Seemi's Spiritual Companion
//
//  xAI Grok API integration with Urdu/Lahori dialect support
//

import Foundation
import Security
import Alamofire

@Observable
@MainActor
class NextElevenAPIService {
    // MARK: - Properties
    private let baseURL = "https://api.x.ai/v1"
    private let model = "grok-4-1-fast-reasoning" // xAI Grok 4.1 Fast Reasoning - 2M token context window
    private let contextWindow = 2000000 // Grok 4.1 Fast's full context window (2 million tokens)
    
    var isLoading: Bool = false
    var error: String?
    
    // MARK: - Keychain Keys
    private let keychainService = "com.seemi.spiritual.xai"
    private let keychainAccount = "api-key"
    
    // MARK: - Singleton
    static let shared = NextElevenAPIService()
    
    private init() {
        // User must set API key in Settings
        if getAPIKey() == nil {
            print("⚠️ No API key found. Please set in Settings.")
        } else {
            print("✅ API key found in Keychain")
        }
    }
    
    // MARK: - Iman's System Prompt (Urdu/Lahori Dialect Support)
    // Optimized for xAI Grok 4.1 Fast with 2M token context window and excellent multilingual capabilities
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
        // Get API key from Keychain
        guard let apiKey = getAPIKey(), !apiKey.isEmpty, apiKey != "YOUR_NEXTELEVEN_API_KEY_HERE" else {
            print("❌ API Key missing or invalid")
            completion(.failure(APIError.missingAPIKey))
            return
        }
        
        print("✅ Using API Key: \(String(apiKey.prefix(10)))...")
        print("✅ Model: \(model)")
        print("✅ Endpoint: \(baseURL)/chat/completions")
        
        isLoading = true
        error = nil
        
        // Build messages array with system prompt + history + new message
        var messages: [[String: String]] = [
            ["role": "system", "content": getImanSystemPrompt()]
        ]
        
        // Add conversation history (last 100 messages - with 2M token context, we can use much more)
        // Grok 4.1 Fast can handle extensive conversation history
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
            max_tokens: 4000, // Increased output tokens for richer responses (2M context allows this)
            temperature: 0.8,
            top_p: 0.95,
            stream: false
        )
        
        // Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        // Make API request
        AF.request(
            "\(baseURL)/chat/completions",
            method: .post,
            parameters: requestBody,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: ChatCompletionResponse.self) { response in
            Task { @MainActor in
                self.isLoading = false
                
                switch response.result {
                case .success(let chatResponse):
                    print("✅ API Response received")
                    if let content = chatResponse.choices.first?.message.content {
                        print("✅ Content: \(String(content.prefix(50)))...")
                        completion(.success(content))
                    } else {
                        print("❌ Empty response from API")
                        completion(.failure(APIError.emptyResponse))
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error.localizedDescription)")
                    self.error = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
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
            print("✅ API Key saved successfully to Keychain")
        } else {
            print("⚠️ Error saving API Key: \(status)")
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
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let key = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return key
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
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Please add your xAI API key in Settings"
        case .emptyResponse:
            return "Received empty response from Grok"
        case .invalidResponse:
            return "Invalid response format from xAI"
        }
    }
}
