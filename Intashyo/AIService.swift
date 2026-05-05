// AIService.swift — Anthropic Claude API integration
// IMPORTANT: Replace PROXY_BASE_URL with your backend proxy URL.
// Never ship the raw Anthropic API key in the client app.

import Foundation
import Observation

// MARK: - Chat Message

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: ChatRole
    let content: String
    var isTyping: Bool = false
}

enum ChatRole {
    case user
    case assistant
}

// MARK: - API Models (Codable)

private struct APIMessage: Codable {
    let role: String
    let content: String
}

private struct APIRequest: Codable {
    let model: String
    let max_tokens: Int
    let system: String
    let messages: [APIMessage]
}

private struct APIResponse: Codable {
    let content: [ContentBlock]
    struct ContentBlock: Codable {
        let type: String
        let text: String?
    }
}

// MARK: - AI Service

@Observable
@MainActor
final class AIService {
    // ⚠️ Set this to your proxy backend URL before shipping.
    // For local development: use direct Anthropic URL + key in Debug only.
    #if DEBUG
    private let baseURL = "https://api.anthropic.com/v1/messages"
    private let apiKey  = "YOUR_ANTHROPIC_API_KEY_HERE"   // Replace before shipping
    #else
    private let baseURL = "https://YOUR-PROXY-BACKEND.example.com/api/chat"
    private let apiKey  = ""
    #endif

    private let model = "claude-haiku-4-5-20251001"

    func sendMessage(
        conversation: [ChatMessage],
        userMessage: String,
        language: String
    ) async throws -> String {
        let systemPrompt = """
        You are Intashyo, a warm and knowledgeable guide for African immigrants \
        settling in the United States. The user has selected \(language) as their \
        language. Answer all questions helpfully, concisely, and in \(language) only. \
        Keep responses under 80 words. Focus on practical, actionable information \
        about housing, food assistance, healthcare, legal aid, employment, and \
        documents. If you don't know something specific to the user's city, say so \
        and suggest they call 211.
        """

        let messages: [APIMessage] = conversation
            .filter { !$0.isTyping }
            .map { APIMessage(role: $0.role == .user ? "user" : "assistant", content: $0.content) }
            + [APIMessage(role: "user", content: userMessage)]

        let body = APIRequest(
            model: model,
            max_tokens: 256,
            system: systemPrompt,
            messages: messages
        )

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        #if DEBUG
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        #endif
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw AIError.invalidResponse
        }
        switch http.statusCode {
        case 200:
            let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
            return decoded.content.first(where: { $0.type == "text" })?.text ?? ""
        case 429:
            throw AIError.rateLimited
        default:
            throw AIError.serverError(http.statusCode)
        }
    }
}

enum AIError: LocalizedError {
    case invalidResponse
    case rateLimited
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid server response."
        case .rateLimited:     return "Rate limited."
        case .serverError(let code): return "Server error \(code)."
        }
    }
}
