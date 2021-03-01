import Combine
import HTMLReader
import JavaScriptCore

// MARK: - LDRRequest + Session
extension LDRRequest where Response == LDRSessionResponse {
  // MARK: static api
  
  /// Session Request
  /// - Parameters:
  ///   - username: username string
  ///   - password: password string
  ///   - authencityToken: authencityToken string
  /// - Returns:
  static func session(username: String, password: String, authenticityToken: String) -> Self {
    let url = URL(ldrPath: LDRApi.session)
    let body = ["username": username, "password": password, "authenticity_token": authenticityToken].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: .defaultHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRSessionResponse
struct LDRSessionResponse {
  // MARK: property
  let data: Data
  
  var apiKey: String {
    HTMLDocument(data: data, contentTypeHeader: nil)
      .nodes(matchingSelector: "script")
      .flatMap { $0.children }
      .compactMap { $0 as? HTMLNode }
      .map {
        let jsContext = JSContext()
        jsContext?.evaluateScript($0.textContent)
        jsContext?.evaluateScript("let getApiKey = () => { return ApiKey }")
        if let key = jsContext?.evaluateScript("getApiKey()").toString(), key != "undefined" {
          return key
        }
        return ""
      }
      .reduce("", +)
  }
}

// MARK: - URLSession + LDRSessionResponse
extension URLSession {

  // MARK: public api
  
  func publisher(
    for request: LDRRequest<LDRSessionResponse>
  ) -> AnyPublisher<LDRSessionResponse, Swift.Error> {
    // swiftlint:disable trailing_closure
    dataTaskPublisher(for: request.urlRequest)
      .mapError(LDRError.networking)
      .handleEvents(receiveOutput: {
        HTTPCookieStorage.shared.addCookies(urlResponse: $0.response)
      })
      .map { LDRSessionResponse(data: $0.data) }
      .eraseToAnyPublisher()
    // swiftlint:enable trailing_closure
  }
}
