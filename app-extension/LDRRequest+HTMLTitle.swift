import Combine
import HTMLReader
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
  let url: URL
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
        let title = HTMLDocument(data: $0.data, contentTypeHeader: "text/html")
          .nodes(matchingSelector: "title")
          .map { $0.textContent }
          .reduce("", +)
        return LDRHTMLTitleResponse(
          title: title == "" ? "\(request.url.host ?? "")/\(request.url.path)" : title,
          url: request.url
        )
      }
      .eraseToAnyPublisher()
  }
}
