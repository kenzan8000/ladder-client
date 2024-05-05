import Foundation

// MARK: - NetworkingError

enum NetworkingError: Error {
    case invalidURL
    case noAPIKey
    case noAuthenticityToken
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Fastladder root URL is not definied yet or invalid. Please set it up from \"Sign in\"."
        case .noAPIKey:
            return "Failed to get Fastladder API key. Please sign in from \"Sign in\"."
        case .noAuthenticityToken:
            return "Failed to get Fastladder authenticity token. Please confirm if you fill the right information on the sign-in form."
        }
    }
}
