@testable import ladder_client

// MARK: - LDRFeedRowContent
struct LDRFeedRowContent: FeedSubsUnread, Hashable {
  let title: String
  var unreadCount: Int
  let state: LDRFeedSubsUnreadState
  
  static func fixture(
    title: String = "はてなブックマーク - お気に入り",
    unreadCount: Int = 187,
    state: LDRFeedSubsUnreadState
  ) -> LDRFeedRowContent {
    LDRFeedRowContent(title: title, unreadCount: unreadCount, state: state)
  }
}
