import Foundation
import HTMLReader

// MARK: - LDRRequest + RSSFeed
extension LDRRequest where Response == LDRRSSFeedResponse {
  // MARK: static api
  
  /// Request finding RSS feeds from the URL
  /// - Parameters:
  ///   - URL: HTML `URL`
  /// - Returns: `LDRRequest`
  static func rssFeed(url: URL) -> Self {
    LDRRequest(url: url, method: .get([]))
  }
}

// MARK: - LDRRSSFeedResponse
struct LDRRSSFeedResponse: Codable {
  // MARK: property
  
  let feeds: [LDRRSSFeed]
}

// MARK: - LDRRSSFeed
struct LDRRSSFeed: Codable {
  // MARK: property
  
  /// RSS Feed title
  let title: String

  /// RSS Feed URL
  let url: URL
}

// MARK: - LDRRSSFeedURLSession
protocol LDRRSSFeedURLSession {
  func response(
    for request: LDRRequest<LDRRSSFeedResponse>
  ) async throws -> (LDRRSSFeedResponse, URLResponse)
}

// MARK: - LDRDefaultRSSFeedURLSession
class LDRDefaultRSSFeedURLSession: LDRRSSFeedURLSession {
  // MARK: property
  
  let urlSession: URLSessionProtocol

  // MARK: initializer
  
  init(urlSession: URLSessionProtocol = URLSession.shared) {
    self.urlSession = urlSession
  }

  // MARK: public api
  func response(
    for request: LDRRequest<LDRRSSFeedResponse>
  ) async throws -> (LDRRSSFeedResponse, URLResponse) {
    let (data, urlResponse) = try await urlSession.data(for: request.urlRequest)
    let feeds = HTMLDocument(data: data, contentTypeHeader: "text/html")
      .nodes(matchingSelector: "link")
      .compactMap { (element: HTMLElement) -> LDRRSSFeed? in
        let isRSSFeed = element.attributes.contains {
          $0.key == "type" && $0.value == "application/rss+xml"
        }
        let title = element.attributes
          .first { $0.key == "title" }
          .map { $0.value }
        let urlString = element.attributes
          .first { $0.key == "href" }
          .map { $0.value }
        guard isRSSFeed, let title, let urlString, let url = URL(string: urlString) else {
          return nil
        }
        return LDRRSSFeed(title: title, url: url)
      }
    return (LDRRSSFeedResponse(feeds: feeds), urlResponse)
  }
}
