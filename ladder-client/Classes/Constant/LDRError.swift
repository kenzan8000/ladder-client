import Foundation

// MARK: - LDRError
enum LDRError: Error {
    case decoding(Error)
    case deleteModel
    case networking(URLError)
    case rssFeedNotFound
    case saveModel
    case others(String)
    
    var legibleDescription: String {
        switch self {
        case .decoding:
            return "Decode failed. Received unexpected response from your Fastladder."
        case .deleteModel:
            return "Failed to delete the record."
        case .networking:
            return "Connection failed."
        case .rssFeedNotFound:
            return "RSS feeds not found."
        case .saveModel:
            return "Failed to save the record."
        case let .others(description):
            return description
        }
    }
}
