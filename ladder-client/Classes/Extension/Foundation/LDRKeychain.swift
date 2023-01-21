import Foundation
import KeychainAccess

// MARK: - LDRKeychain
protocol LDRKeychain {
  var apiKey: String? { get set }
  var cookie: String? { get set }
  var ldrUrlString: String? { get set }
  var feedSubsUnreadSegmentString: String? { get set }
  var reloadTimestamp: String? { get set }
  var reloadTimestampIsExpired: Bool { get }
 
  /// save cookies by url response
  ///
  /// - Parameter urlResponse: url response
  func addCookies(urlResponse: URLResponse)
  func removeAllCookies()
  
  func updateReloadTimestamp()
}

// MARK: - LDRKeychainStore
class LDRKeychainStore: LDRKeychain {
  // MARK: property
  
  let service: String
  let group: String
  private var keychain: Keychain {
    Keychain(service: service, accessGroup: group)
  }
  
  var apiKey: String? {
    get { keychain["LDRKeychain.apiKey"] }
    set { keychain["LDRKeychain.apiKey"] = newValue }
  }
  
  var cookie: String? {
    get { keychain["LDRKeychain.cookie"] }
    set { keychain["LDRKeychain.cookie"] = newValue }
  }
  
  var ldrUrlString: String? {
    get { keychain["LDRKeychain.ldrUrlString"] }
    set { keychain["LDRKeychain.ldrUrlString"] = newValue }
  }
  
  var feedSubsUnreadSegmentString: String? {
    get { keychain["LDRKeychain.feedSubsUnreadSegmentString"] }
    set { keychain["LDRKeychain.feedSubsUnreadSegmentString"] = newValue }
  }
  
  var reloadTimestamp: String? {
    get { keychain["LDRKeychain.reloadTimestamp"] }
    set { keychain["LDRKeychain.reloadTimestamp"] = newValue }
  }
  var reloadTimestampIsExpired: Bool {
    Date() > Date(timeIntervalSince1970: Double(reloadTimestamp ?? "0.0") ?? 0.0)
  }
 
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
    cookie = HTTPCookieStorage.shared.cookies?
      .compactMap { (cookie: HTTPCookie) -> HTTPCookie? in
        guard let host = responseUrl.host,
              cookie.domain.hasSuffix(host) else {
          return nil
        }
        return cookie
      }
      .map { "\($0.name)=\($0.value);" }
      .reduce("", +)
  }
  
  func removeAllCookies() {
    HTTPCookieStorage.shared.removeCookies(since: .init(timeIntervalSince1970: 0))
    cookie = nil
  }
  
  // MARK: initializer
  
  init(service: String, group: String) {
    self.service = service
    self.group = group
  }
  
  // MARK: public api
  
  /// Updates reloadTimestamp
  func updateReloadTimestamp() {
    reloadTimestamp = String(Date().timeIntervalSince1970 + 3600.0)
  }
}
