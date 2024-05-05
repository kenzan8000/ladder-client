import Foundation

// MARK: - NetworkingError

enum NetworkingError: Error {
    case invalidURL
    case noAPIKey
    case noAuthenticityToken
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Fastladder root URL is not definied or invalid. Please set it up from the \"Sign in\" form."
        case .noAPIKey:
            return "Failed to get Fastladder API key. Please check if you fill the right information on the \"Sign in\" form."
        case .noAuthenticityToken:
            return "Failed to get Fastladder authenticity token. Please check if you fill the right information on the \"Sign in\" form."
        }
    }
}
