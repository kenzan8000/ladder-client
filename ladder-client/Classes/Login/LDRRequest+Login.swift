import Combine
import HTMLReader

// MARK: - DRRequest + Login
extension LDRRequest where Response == LDRLoginResponse {
  // MARK: static api
  
  /// Login Request
  /// - Parameters:
  ///   - username: username string
  ///   - password: password string
  /// - Returns: 
  static func login(username: String, password: String) -> Self {
    LDRRequest(
      url: URL(ldrPath: LDR.login),
      method: .get(
        [
          .init(name: "username", value: username),
          .init(name: "password", value: password),
        ]
      )
    )
  }
}

// MARK: - LDRLoginResponse
struct LDRLoginResponse {
  // MARK: property
  let data: Data
  let response: URLResponse
  
  var authencityToken: String {
    var authenticityToken = ""
    let document = HTMLDocument(data: data, contentTypeHeader: nil)
    guard let form = document.firstNode(matchingSelector: "form") else {
      return authenticityToken
    }
    for child in form.children {
      guard let htmlElement = child as? HTMLElement else {
        continue
      }
      if htmlElement["name"] != "authenticity_token" {
        continue
      }
      authenticityToken = htmlElement["value"] ?? ""
      break
    }
    return authenticityToken
  }
}

// MARK: - URLSession + Login
extension URLSession {

  // MARK: public api
  
  func publisher(
    for request: LDRRequest<LDRLoginResponse>
  ) -> AnyPublisher<LDRLoginResponse, Swift.Error> {
    dataTaskPublisher(for: request.urlRequest)
      .mapError(Error.networking)
      .map { LDRLoginResponse(data: $0.data, response: $0.response) }
      .eraseToAnyPublisher()
  }

}

// MARK: - LDRRequest + Session
extension LDRRequest where Response == Data {
  // MARK: static api
  
  /// Session Request
  /// - Parameters:
  ///   - username: username string
  ///   - password: password string
  ///   - authencityToken: authencityToken string
  /// - Returns:
  static func session(username: String, password: String, authenticityToken: String) -> Self {
    LDRRequest(
      url: URL(ldrPath: LDR.session),
      method: .post(
        ["username": username, "password": password, "authenticity_token": authenticityToken].HTTPBodyValue()
      )
    )
  }
}
