import Foundation


/// MARK: - MutableURLRequest+Cookie
extension MutableURLRequest {

    /// MARK: - public api

    /// set cookies to http header
    func setCookies() {
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
