import Foundation
import KeychainAccess

// MARK: - HTTPCookieStorage+Cookie
extension HTTPCookieStorage {

  // MARK: - public api

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
    let host = URL(ldrPath: LDRApi.login).host
    HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: responseUrl).forEach {
      HTTPCookieStorage.shared.setCookie($0)
      if let host = host, $0.domain.hasSuffix(host) {
        Keychain(service: .ldrServiceName, accessGroup: .ldrSuiteName)[LDRKeychain.session] = $0.value
      }
    }
  }

}
