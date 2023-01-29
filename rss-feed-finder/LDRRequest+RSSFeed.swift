import Combine
import HTMLReader
import KeychainAccess

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
struct LDRRSSFeedResponse {
  // MARK: property
  
  let feeds: [LDRRSSFeed]
}

// MARK: - LDRRSSFeed
struct LDRRSSFeed {
  // MARK: property
  
  /// RSS Feed title
  let title: String
  
  /// RSS Feed URL
  let url: URL
}
