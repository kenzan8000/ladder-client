import Foundation


/// MARK: - MutableURLRequest+Cookie
extension MutableURLRequest {

    /// MARK: - public api

    /**
     * set cookies
     */
    func setCookies() {
        let cookies = HTTPCookieStorage.shared.cookies
        if cookies == nil { return }

        var value = ""
        for cookie in cookies! {
            value = "\(value)\(cookie.name)=\(cookie.domain);"
        }
        self.setValue(value, forHTTPHeaderField: "Cookie")
    }

}
