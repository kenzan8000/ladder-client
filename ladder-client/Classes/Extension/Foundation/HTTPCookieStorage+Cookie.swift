import Foundation

extension HTTPCookieStorage {
    func cookieString(host: String?) -> String? {
        guard let host else {
            return nil
        }
        return cookies?
            .compactMap { $0.domain.hasSuffix(host) ? $0 : nil }
            .map { "\($0.name)=\($0.value);" }
            .reduce("", +)
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
            setCookie($0)
        }
    }
}
