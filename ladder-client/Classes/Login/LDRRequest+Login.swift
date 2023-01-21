import Combine
import HTMLReader

// MARK: - DRRequest + Login
extension LDRRequest where Response == LDRLoginResponse {
  // MARK: static api
  
  /// Login Request
  /// - Parameters:
  ///   - ldrUrlString: domain + url path (optional) that runs fastladder app
  ///   - username: username string
  ///   - password: password string
  /// - Returns: 
  static func login(ldrUrlString: String?, username: String, password: String) -> Self {
    LDRRequest(
      url: URL(ldrUrlString: ldrUrlString, ldrPath: LDRApi.login),
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

// MARK: - LDRLoginURLSession
protocol LDRLoginURLSession {
  func publisher(
    for request: LDRRequest<LDRLoginResponse>,
    ldrUrlString: String?
  ) -> AnyPublisher<LDRSessionResponse, LDRError>
}

// MARK: - LDRDefaultLoginURLSession
struct LDRDefaultLoginURLSession: LDRLoginURLSession {
  // MARK: property
  
  let keychain: LDRKeychain
  private let urlSession = URLSession.shared

  // MARK: public api
  
  func publisher(
    for request: LDRRequest<LDRLoginResponse>,
    ldrUrlString: String?
  ) -> AnyPublisher<LDRSessionResponse, LDRError> {
    urlSession.dataTaskPublisher(for: request.urlRequest)
      .validate(statusCode: 200..<300)
      .mapError { urlError -> LDRError in
        let error = LDRError.networking(urlError)
        logger.error("\(logger.prefix(), privacy: .private)\(error.legibleDescription, privacy: .private)")
        return error
      }
      .map { LDRLoginResponse(data: $0.data, response: $0.response) }
      .flatMap { result -> AnyPublisher<LDRSessionResponse, LDRError> in
        var username = ""
        var password = ""
        if case let .get(queryItems) = request.method {
          username = queryItems.first { $0.name == "username" }?.value ?? ""
          password = queryItems.first { $0.name == "password" }?.value ?? ""
        }
        return LDRDefaultSessionURLSession(keychain: keychain).publisher(
          for: .session(ldrUrlString: ldrUrlString, username: username, password: password, authenticityToken: result.authencityToken)
        )
      }
      .eraseToAnyPublisher()
  }
}
