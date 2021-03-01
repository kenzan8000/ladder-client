import Foundation
import KeychainAccess

// MARK: - HTTPCookieStorage + Cookie
extension HTTPCookieStorage {

  // MARK: public api

  /// save cookies by url response
  ///
  /// - Parameter urlResponse: url response
  func addCookies(urlResponse: URLResponse) {
    guard let response = urlResponse as? HTTPURLResponse,
          let responseUrl = response.url else {
      return
    }
    var headerFields: [String: String] = [:]
    response.allHeaderFields
      .forEach { key, value in
        if let key = key as? String, let value = value as? String {
          headerFields[key] = value
        }
      }
    HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: responseUrl).forEach {
      HTTPCookieStorage.shared.setCookie($0)
    }
  }

}

// MARK: - String + Cookie
extension String {
  /// get cookies string for http header
  /// - Parameter host: host name for cookie
  /// - Returns: http header string
  static func ldrCookie(host: String) -> String {
    HTTPCookieStorage.shared.cookies?
      .compactMap { $0.domain.hasSuffix(host) ? $0 : nil }
      .map { "\($0.name)=\($0.value);" }
      .reduce("", +) ?? ""
  }
}
