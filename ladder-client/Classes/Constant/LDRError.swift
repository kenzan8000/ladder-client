import Foundation

// MARK: - LDRError
enum LDRError: Swift.Error {
  case networking(URLError)
  case decoding(Swift.Error)
  case deleteModelsFailed
  case saveModelsFailed
  case failed(String)
  
  var legibleDescription: String {
    switch self {
    case .networking:
      return "Connection failed."
    case .decoding:
      return "Decode failed. Received unexpected response from your Fastladder."
    case .deleteModelsFailed:
      return "Failed to delete the record."
    case .saveModelsFailed:
      return "Failed to save the record."
    case let .failed(description):
      return description
    }
  }
}
