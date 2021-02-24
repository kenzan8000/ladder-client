import Foundation

// MARK: - LDRError
enum LDRError: Swift.Error {
  case networking(URLError)
  case decoding(Swift.Error)
  // core data
  case deleteModelsFailed
  case saveModelsFailed
  // internet connection
  case notReachable
  // failed for some reason
  case failed(String)
  // login
  case invalidUsername
  case invalidPassword
  case invalidLdrUrl
  case invalidUsernameOrPassword
  case invalidUrlOrUsernameOrPassword
  case invalidAuthenticityToken
  // api
  case invalidApiKey
}
