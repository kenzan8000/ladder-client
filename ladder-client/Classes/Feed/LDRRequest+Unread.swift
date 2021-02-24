import Combine
import Foundation

// MARK: - LDRRequest + Unread
extension LDRRequest where Response == LDRUnreadResponse {
  // MARK: static api
  
  /// Request retrieving unread articles in the feed
  /// - Parameters:
  ///   - subscribeId: feed subscribe id
  /// - Returns:
  static func unread(subscribeId: String) -> Self {
    let url = URL(ldrPath: LDR.Api.unread)
    let body = ["ApiKey": LDRRequestHelper.getApiKey() ?? "", "subscribe_id": subscribeId].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: LDRRequestHelper.createCookieHttpHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRUnreadResponse
struct LDRUnreadResponse: Decodable {
  // MARK: prooperty
  let subscribeId: Int
  let items: [LDRUnreadItem]
  let channel: LDRChannel
}

// MARK: - LDRUnreadItem
struct LDRUnreadItem: Decodable {
  // MARK: prooperty
  let id: Int
  let title: String
  let category: String
  let body: String
  let link: String
}

// MARK: - LDRChannel
struct LDRChannel: Decodable {
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
