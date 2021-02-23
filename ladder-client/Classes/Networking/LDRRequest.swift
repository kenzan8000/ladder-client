import Foundation

// MARK: - LDRRequest
struct LDRRequest<Response> {
  // MARK: property
  let url: URL
  let method: HttpMethod
  var headers: [String: String] = [:]
  
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

// MARK: - LDRResponse
struct LDRResponse {
  // MARK: property
  let data: Data
  let response: URLResponse
  
  // MARK: initialization
  init(data: Data, response: URLResponse) {
    HTTPCookieStorage.shared.addCookies(urlResponse: response)
    self.data = data
    self.response = response
  }
}
