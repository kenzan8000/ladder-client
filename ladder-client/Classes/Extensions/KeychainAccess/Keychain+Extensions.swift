import Foundation
import KeychainAccess

// MARK: - KeychainKey

private enum KeychainKey {
    static let apiKey: String = "fastladder.api-key"
    static let cookie: String = "fastladder.cookie"
    static let rootURL: String = "fastladder.root-url"
}

// MARK: - KeychainProtocol

protocol KeychainProtocol {
    var apiKey: String? { get set }
    var cookie: String? { get set }
    var rootURL: URL? { get set }
}

// MARK: - Keychain Extension

extension Keychain: KeychainProtocol {
    var apiKey: String? {
        get { self[KeychainKey.apiKey] }
        set { self[KeychainKey.apiKey] = newValue }
    }
    
    var cookie: String? {
        get { self[KeychainKey.cookie] }
        set { self[KeychainKey.cookie] = newValue }
    }
    
    var rootURL: URL? {
        get { URLComponents(string: self[KeychainKey.rootURL] ?? "")?.url }
        set { self[KeychainKey.rootURL] = newValue?.absoluteString }
    }
}
