import Foundation

// MARK: - LDRError
enum LDRError: Error {
  case networking(URLError)
  case decoding(Error)
  case deleteModel
  case saveModel
  case others(String)
  
  var legibleDescription: String {
    switch self {
    case .networking:
      return "Connection failed."
    case .decoding:
      return "Decode failed. Received unexpected response from your Fastladder."
    case .deleteModel:
      return "Failed to delete the record."
    case .saveModel:
      return "Failed to save the record."
    case let .others(description):
      return description
    }
  }
}
