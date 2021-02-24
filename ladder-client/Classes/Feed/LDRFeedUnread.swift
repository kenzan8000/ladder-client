// MARK: - LDRFeedUnread
final class LDRFeedUnread {
  // MARK: enum
  enum State: Int {
    case unloaded = 0
    case unread = 1
    case read = 2
  }
  
  // MARK: prooperty
  var state: State = .unloaded
  let response: LDRUnreadResponse
  
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
