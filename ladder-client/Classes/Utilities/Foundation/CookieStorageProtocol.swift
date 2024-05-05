import Foundation

// MARK: - CookieStorageProtocol

protocol CookieStorageProtocol {
    func cookieString(host: String?) -> String?
    func addCookies(urlResponse: URLResponse)
}
