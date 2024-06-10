import Foundation

// MARK: - NetworkingResponse

/// Model representing general networking response from Fastladder
struct NetworkingResponse: Codable, Equatable, Sendable {
    // MARK: - Private Enums
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case isSucceeeded = "isSuccess"
    }
    
    // MARK: Public properties
    
    let errorCode: Int
    
    let isSucceeeded: Bool
}
