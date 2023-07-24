import Foundation

// MARK: - LDRRequest
struct LDRRequest<Response> {
    // MARK: property
    let url: URL
    let method: HttpMethod
    var headers: LDRRequestHeader = [:]
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        switch method {
        case .post(let data), .put(let data):
            request.httpBody = data
        case let .get(queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                preconditionFailure("Couldn't create a url from components.")
            }
            request = URLRequest(url: url)
        default:
            break
        }
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }

    // MARK: HttpMethod
    enum HttpMethod: Equatable {
        case get([URLQueryItem])
        case put(Data?)
        case post(Data?)
        case delete

        var name: String {
            switch self {
            case .get:
                return "GET"
            case .put:
                return "PUT"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            }
        }
    }
}

// MARK: - LDRRequestHeader
typealias LDRRequestHeader = [String: String]
extension LDRRequestHeader {
    static func defaultHeader(url: URL, body: Data?, cookie: String?) -> LDRRequestHeader {
        [
            "Content-Type": "application/json",
            "Content-Length": "\(String(describing: body?.count ?? 0))",
            "Cookie": cookie ?? "",
        ]
    }
    
    static func defaultHTMLHeader(cookie: String?) -> LDRRequestHeader {
        [
            "Cookie": cookie ?? "",
        ]
    }
    
    static func cookielessHeader(body: Data?) -> LDRRequestHeader {
        [
            "Content-Type": "application/json",
            "Content-Length": "\(String(describing: body?.count ?? 0))",
        ]
    }
    
    static func cookielessHTMLHeader() -> LDRRequestHeader {
        [:]
    }
}
