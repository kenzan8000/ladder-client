import Foundation

// MARK: - KeychainProtocol

protocol KeychainProtocol {
    var apiKey: String? { get set }
    var cookie: String? { get set }
    var rootURL: URL? { get set }
}
