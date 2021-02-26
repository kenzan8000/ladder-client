import Combine
import HTMLReader
import JavaScriptCore
import KeychainAccess

// MARK: - LDRRequest + HTMLTitle
extension LDRRequest where Response == LDRHTMLTitleResponse {
  // MARK: static api
  
  /// Request adding a link to read later list
  /// - Parameters:
  ///   - link: pin url
  ///   - title: pin title
  /// - Returns: LDRRequest
  static func htmlTitle(url: URL) -> Self {
    return LDRRequest(
      url: url,
      method: .get([])
    )
  }
}

// MARK: - LDRHTMLTitleResponse
struct LDRHTMLTitleResponse: Decodable {
  // MARK: prooperty
  let title: String
}

// MARK: - URLSession + LDRHTMLTitleResponse
extension URLSession {

  // MARK: public api
  
  func publisher(
    for request: LDRRequest<LDRHTMLTitleResponse>
  ) -> AnyPublisher<LDRHTMLTitleResponse, Swift.Error> {
    dataTaskPublisher(for: request.urlRequest)
      .mapError(LDRError.networking)
      .map {
        let document = HTMLDocument(data: $0.data, contentTypeHeader: nil)
        let jsContext = JSContext()
        jsContext?.evaluateScript(document.textContent)
        jsContext?.evaluateScript("let getTitle = () => { return document.title }")
        return LDRHTMLTitleResponse(
          title: jsContext?.evaluateScript("getTitle()").toString() ?? request.url.absoluteString
        )
      }
      .eraseToAnyPublisher()
  }
}
