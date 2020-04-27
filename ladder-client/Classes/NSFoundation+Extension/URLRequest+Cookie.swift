import Alamofire
import Foundation


/// MARK: - URLRequest+Cookie
extension URLRequest {

    /// MARK: - public api

    /// get cookies for http header
    ///
    /// - Parameter host: host name for cookie
    /// - Returns: http header
    static func getCookies(host: String?) -> HTTPHeader? {
        guard let h = host else {
            return nil
        }
        let cookies = HTTPCookieStorage.shared.cookies
        if cookies == nil { return nil }

        var value = ""
        for cookie in cookies! {
            if !(cookie.domain.hasSuffix(h)) { continue }
            value = "\(value)\(cookie.name)=\(cookie.value);"
        }
        return HTTPHeader(name: "Cookie", value: value)
    }

}
