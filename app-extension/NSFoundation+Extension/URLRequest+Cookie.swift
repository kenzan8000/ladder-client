import Foundation


/// MARK: - MutableURLRequest+Cookie
extension URLRequest {

    /// MARK: - public api

    /**
     * set cookies
     */
    mutating func setCookies() {
        let cookies = HTTPCookieStorage.shared.cookies
        if cookies == nil { return }

        var value = ""
        for cookie in cookies! {
            if !(cookie.domain.hasSuffix(self.url!.host!)) { continue }
            value = "\(value)\(cookie.name)=\(cookie.value);"
        }
        self.setValue(value, forHTTPHeaderField: "Cookie")
    }

}
