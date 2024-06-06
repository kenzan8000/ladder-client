import Foundation

// MARK: - URLRequest Extension

extension URLRequest {
    static func networkingRequest(
        method: String,
        rootURL: URL?,
        path: String,
        header: [String: String],
        queryItems: [URLQueryItem]? = nil,
        body: [String: Any]? = nil
    ) throws -> URLRequest {
        guard let rootURL,
        var components = URLComponents(url: rootURL, resolvingAgainstBaseURL: false) else {
            throw NetworkingError.invalidURL
        }
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else {
            throw NetworkingError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        request.allHTTPHeaderFields = header.merging(["Content-Length": "\(request.httpBody?.count ?? 0)"]) { _, new in new }
        return request
    }
}
