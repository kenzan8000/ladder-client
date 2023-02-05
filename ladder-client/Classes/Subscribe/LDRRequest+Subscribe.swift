import Foundation
import HTMLReader

// MARK: - LDRRequest + RSSFolder
extension LDRRequest where Response == LDRSubscribeResponse {
  // MARK: static api
  
  /// Request checking if already subscribed, retrieving the folders, title, and url
  /// - Parameters:
  ///   - feedURL: RSS feed `URL`
  ///   - apiKey: apiKey string
  ///   - ldrUrlString: domain + url path (optional) that runs fastladder app
  ///   - cookie: cookie string
  /// - Returns: `LDRRequest`
  static func subscriptionParam(
    feedUrl: URL,
    apiKey: String?,
    ldrUrlString: String?,
    cookie: String?
  ) -> Self {
    let url = URL(ldrUrlString: ldrUrlString, ldrPath: LDRApi.subscribe)
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    urlComponents?.queryItems = [URLQueryItem(name: "url", value: feedUrl.absoluteString)]
    let body = ["ApiKey": apiKey ?? ""].HTTPBodyValue()
    return LDRRequest(
      url: urlComponents?.url ?? url,
      method: .get([]),
      headers: .defaultHeader(url: url, body: body, cookie: cookie)
    )
  }
}

// MARK: - LDRSubscribeResponse
struct LDRSubscribeResponse: Codable {
  // MARK: property
  
  /// RSS feed title
  let title: String
  
  /// RSS feed URL
  let url: URL
  
  /// flag if RSS feed is already subscribed
  let isSubscribed: Bool
  
  /// available folders to assign to RSS feed
  let folders: [LDRRSSFolder]
}

// MARK: - LDRRSSFolder
struct LDRRSSFolder: Codable {
  // MARK: property
  let id: Int
  let name: String
}

// MARK: - LDRSubscribeURLSession
protocol LDRSubscribeURLSession {
  func response(
    for request: LDRRequest<LDRSubscribeResponse>
  ) async throws -> (LDRSubscribeResponse, URLResponse)
}

// MARK: - LDRDefaultSubscribeURLSession
class LDRDefaultSubscribeURLSession: LDRSubscribeURLSession {
  // MARK: property
  
  let urlSession: URLSessionProtocol
  
  // MARK: initializer
  
  init(urlSession: URLSessionProtocol = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  // MARK: public api
  func response(
    for request: LDRRequest<LDRSubscribeResponse>
  ) async throws -> (LDRSubscribeResponse, URLResponse) {
    let (data, urlResponse) = try await urlSession.data(for: request.urlRequest)
    let html = HTMLDocument(data: data, contentTypeHeader: "text/html")
    let title = ""
    let url = URL(string: "")
    let isSubscribed = false
    let folders = html
      .nodes(matchingSelector: "select")
      .compactMap { (element: HTMLElement) -> LDRRSSFolder? in
        let isRSSFolder = element.attributes.contains {
          $0.key == "id" && $0.value == "folder_id"
        }
        guard isRSSFolder else {
          return nil
        }
        return LDRRSSFolder(id: 0, name: "")
      }
    return (LDRSubscribeResponse(
      title: title,
      url: url!,
      isSubscribed: isSubscribed,
      folders: folders
    ), urlResponse)
  }
}
