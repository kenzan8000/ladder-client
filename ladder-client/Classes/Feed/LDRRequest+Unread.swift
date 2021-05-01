import Combine
import KeychainAccess
import Foundation

// MARK: - LDRRequest + Unread
extension LDRRequest where Response == LDRUnreadResponse {
  // MARK: static api
  
  /// Request retrieving unread articles in the feed
  /// - Parameters:
  ///   - apiKey: apiKey string
  ///   - ldrUrlString: domain + url path (optional) that runs fastladder app
  ///   - subscribeId: feed subscribe id
  /// - Returns:
  static func unread(apiKey: String?, ldrUrlString: String?, subscribeId: Int) -> Self {
    let url = URL(ldrUrlString: ldrUrlString, ldrPath: LDRApi.Api.unread)
    let body = [
      "ApiKey": apiKey ?? "",
      "subscribe_id": "\(subscribeId)"
    ].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: .defaultHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRUnreadResponse
struct LDRUnreadResponse: Codable {
  // MARK: prooperty
  let subscribeId: Int
  let items: [LDRUnreadItem]
  let channel: LDRChannel
}

// MARK: - LDRUnreadItem
struct LDRUnreadItem: Codable {
  // MARK: prooperty
  let id: Int
  let title: String
  let category: String
  let body: String
  let link: String
}

// MARK: - LDRChannel
struct LDRChannel: Codable {
  // MARK: static property
  static let example = LDRChannel(
    id: 34,
    title: "efclのはてなブックマーク",
    description: "efclのはてなブックマーク (46,216)",
    link: "https://b.hatena.ne.jp/efcl/bookmark",
    feedlink: "https://b.hatena.ne.jp/efcl/bookmark.rss"
  )
  
  // MARK: prooperty
  let id: Int
  let title: String
  let description: String
  let link: String
  let feedlink: String
}
