// AIService.swift — Google Gemini API integration
// API key is loaded from GeminiKey.plist (bundled resource, excluded from git).

import Foundation
import Observation

// MARK: - Chat Message

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: ChatRole
    let content: String
}

enum ChatRole {
    case user
    case assistant
}

// MARK: - Gemini API Models

private struct GeminiRequest: Encodable {
    let system_instruction: SystemInstruction
    let contents: [GeminiContent]
    let generationConfig: GenerationConfig

    struct SystemInstruction: Encodable {
        let parts: [Part]
    }
    struct GeminiContent: Encodable {
        let role: String   // "user" | "model"
        let parts: [Part]
    }
    struct Part: Encodable {
        let text: String
    }
    struct GenerationConfig: Encodable {
        let maxOutputTokens: Int
        let temperature: Double
    }
}

private struct GeminiResponse: Decodable {
    let candidates: [Candidate]?
    let error: APIError?

    struct Candidate: Decodable {
        let content: Content
        struct Content: Decodable {
            let parts: [Part]
            struct Part: Decodable {
                let text: String
            }
        }
    }
    struct APIError: Decodable {
        let code: Int
        let message: String
    }
}

// MARK: - AI Service

@Observable
@MainActor
final class AIService {
    // Read key from GeminiKey.plist (bundled resource, excluded from git)
    private var apiKey: String {
        guard let url = Bundle.main.url(forResource: "GeminiKey", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: url),
              let key = dict["GeminiAPIKey"] as? String else { return "" }
        return key
    }

    private let model = "gemini-2.0-flash"

    func sendMessage(
        conversation: [ChatMessage],
        userMessage: String,
        language: String
    ) async throws -> String {
        guard !apiKey.isEmpty else { throw AIError.missingKey }

        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)"
        guard let url = URL(string: endpoint) else { throw AIError.invalidResponse }

        let systemPrompt = """
        You are Intashyo, a warm and knowledgeable guide for African immigrants \
        settling in the United States. The user has selected \(language) as their \
        language. Answer all questions helpfully, concisely, and in \(language) only. \
        Keep responses under 80 words. Focus on practical, actionable information \
        about housing, food assistance, healthcare, legal aid, employment, and \
        documents. If you don't know something specific to the user's city, say so \
        and suggest they call 211.
        """

        // Build conversation history (Gemini uses "user"/"model" roles)
        var contents: [GeminiRequest.GeminiContent] = conversation.map {
            GeminiRequest.GeminiContent(
                role: $0.role == .user ? "user" : "model",
                parts: [.init(text: $0.content)]
            )
        }
        contents.append(GeminiRequest.GeminiContent(role: "user", parts: [.init(text: userMessage)]))

        let body = GeminiRequest(
            system_instruction: .init(parts: [.init(text: systemPrompt)]),
            contents: contents,
            generationConfig: .init(maxOutputTokens: 256, temperature: 0.7)
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else { throw AIError.invalidResponse }

        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)

        if let apiErr = decoded.error {
            if apiErr.code == 429 { throw AIError.rateLimited }
            throw AIError.serverError(apiErr.code)
        }

        guard http.statusCode == 200 else { throw AIError.serverError(http.statusCode) }

        return decoded.candidates?.first?.content.parts.first?.text ?? ""
    }
}

// MARK: - Errors

enum AIError: LocalizedError {
    case missingKey
    case invalidResponse
    case rateLimited
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .missingKey:      return "API key not configured."
        case .invalidResponse: return "Invalid server response."
        case .rateLimited:     return "Rate limited."
        case .serverError(let code): return "Server error \(code)."
        }
    }
}
