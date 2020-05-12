import Foundation
import KeychainAccess


// MARK: - HTTPCookieStorage+Cookie
extension HTTPCookieStorage {

    // MARK: - public api

    /**
     * check if has the cookie
     * @param name cookie name
     * @param domain cookie domain
     * @return ture or false
     */
    func hasCookie(name: String, domain: String) -> Bool {
        var has = false

        let cookies = HTTPCookieStorage.shared.cookies
        if cookies == nil { return has }
        for cookie in cookies! {
            if name != cookie.name { continue }
            if domain != cookie.domain { continue }
            has = true
            break
        }

        return has
    }

    /**
     * add cookies by url response
     * @param httpUrlResponse HTTPURLResponse
     **/
    func addCookies(httpUrlResponse: HTTPURLResponse?) {
        if httpUrlResponse == nil { return }

        var headerFields: [String: String] = [:]
        for (key, value) in httpUrlResponse!.allHeaderFields {
            if !(key is String) { continue }
            if !(value is String) { continue }
            headerFields[key as! String] = value as? String
        }
        if httpUrlResponse!.url == nil { return }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: httpUrlResponse!.url!)
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

    /**
     * delete the cookie
     * @param name cookie name
     * @param domain cookie domain
     */
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

    /**
     * get string value or nil
     * @param name cookie name
     * @param domain cookie domain
     * @return when it has value -> String value, when not -> nil
     */
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
