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
    let headerFields = Dictionary(
      uniqueKeysWithValues: response.allHeaderFields.map { key, value in ("\(key)", "\(value)") }
    )
    HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: responseUrl).forEach {
      HTTPCookieStorage.shared.setCookie($0)
      /*
      Keychain(
        service: .ldrServiceName,
        accessGroup: .ldrSuiteName
      )[LDRKeychain.session] = $0.value
      */
    }
    /*
    guard let response = urlResponse as? HTTPURLResponse else {
      return
    }
    var headerFields: [String: String] = [:]
    for (key, value) in response.allHeaderFields {
      if let k = key as? String, let v = value as? String {
        headerFields[k] = v
      }
    }
    guard let responseUrl = response.url else {
      return
    }
    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: responseUrl)
    for cookie in cookies {
      HTTPCookieStorage.shared.setCookie(cookie)
      let url = URL(ldrPath: LDRApi.login)
      guard let host = url.host else {
        continue
      }
      if cookie.domain.hasSuffix(host) {
        Keychain(
          service: .ldrServiceName,
          accessGroup: .ldrSuiteName
        )[LDRKeychain.session] = cookie.value
      }
    }
    */
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
