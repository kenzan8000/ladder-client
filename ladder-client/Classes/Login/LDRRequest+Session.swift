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
      headers: LDRRequestHelper.createCookieHttpHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRSessionResponse
struct LDRSessionResponse {
  // MARK: property
  let data: Data
  
  var apiKey: String {
    var apiKey = "undefined"
    let document = HTMLDocument(data: data, contentTypeHeader: nil)

    let scripts = document.nodes(matchingSelector: "script")
    for script in scripts {
      for child in script.children {
        guard let htmlNode = child as? HTMLNode else {
          continue
        }
        // parse ApiKey
        let jsText = htmlNode.textContent
        guard let jsContext = JSContext() else {
          continue
        }
        jsContext.evaluateScript(jsText)
        jsContext.evaluateScript("var getApiKey = function() { return ApiKey; };")
        // save ApiKey
        apiKey = jsContext.evaluateScript("getApiKey();").toString()
        if apiKey == "undefined" { continue }
        break
      }
      if apiKey != "undefined" { break }
    }
    return apiKey
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
