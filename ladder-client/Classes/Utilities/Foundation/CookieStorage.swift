import Foundation

// MARK: - CookieStorage
struct CookieStorage: CookieStorageProtocol {
    // MARK: - Private properties
    
    private let httpCookieStorage: HTTPCookieStorage
    
    // MARK: - Init

    init(httpCookieStorage: HTTPCookieStorage = .shared) {
        self.httpCookieStorage = httpCookieStorage
    }

    // MARK: - Public methods

    func cookieString(host: String?) -> String? {
        guard let host else {
            return nil
        }
        return httpCookieStorage.cookies?
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
        for cookie in HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: responseUrl) {
            httpCookieStorage.setCookie(cookie)
        }
    }
}
