import Foundation
@testable import ladder_client

// MARK: - KeychainMock

final class KeychainMock: KeychainProtocol {
    var apiKey: String?
    
    var cookie: String?
    
    var rootURL: URL?
}
