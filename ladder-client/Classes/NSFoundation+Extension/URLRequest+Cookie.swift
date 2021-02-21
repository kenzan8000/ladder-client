import Alamofire
import Foundation

// MARK: - URLRequest+Cookie
extension URLRequest {

    // MARK: - public api

    /// get cookies for http header
    ///
    /// - Parameter host: host name for cookie
    /// - Returns: http header
    static func getCookies(host: String?) -> HTTPHeader? {
        guard let h = host else {
            return nil
        }
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            return nil
        }

        var value = ""
        for cookie in cookies {
            if !(cookie.domain.hasSuffix(h)) { continue }
            value = "\(value)\(cookie.name)=\(cookie.value);"
        }
        return HTTPHeader(name: "Cookie", value: value)
    }
  
  /// get cookies string for http header
  /// - Parameter host: host name for cookie
  /// - Returns: http header string
  static func getCookiesString(host: String?) -> String {
      var value = ""
      guard let h = host else {
          return value
      }
      guard let cookies = HTTPCookieStorage.shared.cookies else {
          return value
      }
      for cookie in cookies {
          if !(cookie.domain.hasSuffix(h)) { continue }
          value = "\(value)\(cookie.name)=\(cookie.value);"
      }
      return value
  }
}
