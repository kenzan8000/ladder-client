import SwiftUI

// MARK: - LDRFeedRow + ViewModel
extension LDRFeedRow {
  // MARK: ViewModel
  struct ViewModel {
    var subsunread: FeedSubsUnread
    var title: String {
      subsunread.title
    }
    var unreadCount: String {
      subsunread.state != .read ? "\(subsunread.unreadCount)" : ""
    }
    var color: Color {
      subsunread.state == .unread ? .blue : .gray
    }
  }
}
