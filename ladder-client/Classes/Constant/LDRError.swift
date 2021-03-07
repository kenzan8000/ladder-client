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
    case let .networking(urlError):
      return urlError.localizedDescription
    case let .decoding(error):
      return error.localizedDescription
    case .deleteModelsFailed:
      return "Failed to delete the record."
    case .saveModelsFailed:
      return "Failed to save the record."
    case let .failed(description):
      return description
    }
  }
}
