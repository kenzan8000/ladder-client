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

// MARK: - LDRUnread
final class LDRUnread {
  // MARK: enum
  enum State: Int {
    case unloaded = 0
    case unread = 1
    case read = 2
  }
  
  // MARK: prooperty
  var state: State = .unloaded
  var response: LDRUnreadResponse
  
  var subscribeId: String {
    "\(response.channel.id)"
  }
  var title: String {
    response.channel.title
  }
  var itemsCount: Int {
    response.items.count
  }
  
  // MARK: initialization
  init(response: LDRUnreadResponse) {
    self.response = response
  }
  
  // MARK: public api
  
  /// read
  func read() {
    if state == State.unread {
      state = State.read
    }
  }
  
  /// get LDRUnreadItem's property by KeyPath
  /// - Parameters:
  ///   - index: item's index
  ///   - keyPath: key path
  /// - Returns: LDRUnreadItem's property
  func getItemValue(at index: Int, keyPath: KeyPath<LDRUnreadItem, String>) -> String? {
    if index < 0 {
      return nil
    } else if index >= response.items.count {
      return nil
    }
    return response.items[index][keyPath: keyPath]
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
  let createdOn: Int
  let modifiedOn: Int
  let link: String
  let author: String
}

// MARK: - LDRChannel
struct LDRChannel: Decodable {
  // MARK: static property
  static let example = LDRChannel(
    id: 34,
    title: "efclのはてなブックマーク",
    description: "efclのはてなブックマーク (46,216)",
    link: "https://b.hatena.ne.jp/efcl/bookmark",
    feedlink: "https://b.hatena.ne.jp/efcl/bookmark.rss",
    createdOn: "2020-06-01T14:37:08.842Z",
    updatedOn: "2021-02-23T07:32:18.605Z",
    modifiedOn: "2021-02-23T07:32:18.567Z",
    subscribersCount: 1
  )
  
  // MARK: prooperty
  let id: Int
  let title: String
  let description: String
  let link: String
  let feedlink: String
  let createdOn: String
  let updatedOn: String
  let modifiedOn: String
  let subscribersCount: Int
}
