import Foundation

// MARK: - NetworkingError

enum NetworkingError: Error {
    case invalidURL
    case noAPIKey
    case noAuthenticityToken
}
