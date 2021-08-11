@testable import ladder_client

// MARK: - LDRFeedSubsUnreadPlaceholder
struct LDRFeedSubsUnreadPlaceholder: LDRFeedSubsUnreadProtocol, Hashable {
  let title: String
  var unreadCount: Int
  let state: LDRFeedSubsUnreadState
  
  static func fixture(
    title: String = "はてなブックマーク - お気に入り",
    unreadCount: Int = 187,
    state: LDRFeedSubsUnreadState
  ) -> LDRFeedSubsUnreadPlaceholder {
    LDRFeedSubsUnreadPlaceholder(title: title, unreadCount: unreadCount, state: state)
  }
}
