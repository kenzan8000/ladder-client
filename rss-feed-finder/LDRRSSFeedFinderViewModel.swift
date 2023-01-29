import Foundation
import HTMLReader

// MARK: - LDRRSSFeedFinderViewModel
struct LDRRSSFeedFinderViewModel {
  // MARK: property
  let urlSession: LDRURLSession
  
  func loadRSSFeeds(from url: URL) async throws -> LDRRSSFeedResponse {
    let (data, _) = try await urlSession.data(from: url)
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
    return LDRRSSFeedResponse(feeds: feeds)
  }
}
