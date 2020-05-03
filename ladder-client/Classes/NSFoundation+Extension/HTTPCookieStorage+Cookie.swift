import Foundation
import KeychainAccess


/// MARK: - HTTPCookieStorage+Cookie
extension HTTPCookieStorage {

    /// MARK: - public api

    /// check if having the cookie
    ///
    /// - Parameters:
    ///   - name: name of cookie
    ///   - domain: domain of cookie
    /// - Returns: Bool value if having the cookie
    func hasCookie(name: String, domain: String) -> Bool {
        var doesHave = false

        let cookies = HTTPCookieStorage.shared.cookies
        if cookies == nil { return doesHave }
        for cookie in cookies! {
            if name != cookie.name { continue }
            if domain != cookie.domain { continue }
            doesHave = true
            break
        }

        return doesHave
    }

    /// save cookies by url response
    ///
    /// - Parameter httpUrlResponse: url response
    func addCookies(httpUrlResponse: HTTPURLResponse?) {
        guard let response = httpUrlResponse else {
            return
        }

        var headerFields: [String: String] = [:]
        for (key, value) in response.allHeaderFields {
            if !(key is String) { continue }
            if !(value is String) { continue }
            headerFields[key as! String] = value as? String
        }
        if response.url == nil { return }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: response.url!)
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)

            let url = LDRUrl(path: LDR.login)
            if url != nil && cookie.domain.hasSuffix(url!.host!) {
                Keychain(
                    service: LDRKeychain.serviceName,
                    accessGroup: LDRKeychain.suiteName
                )[LDRKeychain.session] = cookie.value
            }
        }
    }

    /// delete the cookie
    ///
    /// - Parameters:
    ///   - name: cookie name
    ///   - domain: cookie domain
    func deleteCookie(name: String, domain: String) {
        let cookies = HTTPCookieStorage.shared.cookies
        if cookies == nil { return }

        var deletingCookies: [HTTPCookie] = []
        for cookie in cookies! {
            if name != cookie.name { continue }
            if domain != cookie.domain { continue }
            deletingCookies.append(cookie)
        }

        for cookie in deletingCookies {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
    }

    /// returns string value of cookie or nil if not existed
    ///
    /// - Parameters:
    ///   - name: cookie name
    ///   - domain: cookie domain
    /// - Returns: string value of cookie or nil if not existed
    func value(name: String, domain: String) -> String? {
        let cookies = HTTPCookieStorage.shared.cookies
        if cookies == nil { return nil }

        for cookie in cookies! {
            if name != cookie.name { continue }
            if domain != cookie.domain { continue }
            return cookie.value
        }

        return nil
    }

}
