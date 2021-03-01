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
      url: URL(ldrPath: LDRApi.login),
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
    HTMLDocument(data: data, contentTypeHeader: nil)
      .firstNode(matchingSelector: "form")?.children
      .compactMap { $0 as? HTMLElement }
      .compactMap { (element: HTMLElement) in
        element["name"] == "authenticity_token" ? element["value"] : nil
      }
      .reduce("", +) ?? ""
  }
}

// MARK: - URLSession + LDRLoginResponse
extension URLSession {

  // MARK: public api
  
  func publisher(
    for request: LDRRequest<LDRLoginResponse>
  ) -> AnyPublisher<LDRSessionResponse, Swift.Error> {
    // swiftlint:disable trailing_closure
    dataTaskPublisher(for: request.urlRequest)
      .mapError(LDRError.networking)
      .handleEvents(receiveOutput: {
        HTTPCookieStorage.shared.addCookies(urlResponse: $0.response)
      })
      .map { LDRLoginResponse(data: $0.data, response: $0.response) }
      .flatMap { result -> AnyPublisher<LDRSessionResponse, Swift.Error> in
        var username = ""
        var password = ""
        if case let .get(queryItems) = request.method {
          username = queryItems.first { $0.name == "username" }?.value ?? ""
          password = queryItems.first { $0.name == "password" }?.value ?? ""
        }
        return URLSession.shared.publisher(
          for: .session(username: username, password: password, authenticityToken: result.authencityToken)
        )
      }
      .eraseToAnyPublisher()
    // swiftlint:enable trailing_closure
  }
}
