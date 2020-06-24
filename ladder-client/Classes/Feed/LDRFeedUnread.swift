import SwiftyJSON

// MARK: - LDRFeedUnread
class LDRFeedUnread {
    
    // MARK: - enum
    
    enum State {
        static let unloaded = 0
        static let unread = 1
        static let read = 2
        static let noUnread = 3
    }
    
    // MARK: - property

    var subscribeId: String
    var items: [JSON]
    var state: Int

    // MARK: - initialization

    /// initializer
    ///
    /// - Parameter subscribeId: subscribe id
    init(subscribeId: String) {
        self.subscribeId = subscribeId
        self.items = []
        self.state = State.unloaded
    }

    // MARK: - public api

    /// request unread api
    func request() {
        LDRFeedOperationQueue.shared.requestUnread(subscribeId: self.subscribeId) { [unowned self] (json: JSON?, error: Error?) -> Void in
            if let e = error {
                LDRLOG(e.localizedDescription)
            }
            if let items = json?["items"] {
                self.items = items.arrayValue
            }
            if self.items.isEmpty {
                self.state = State.noUnread
            } else {
                self.state = State.unread
            }
            NotificationCenter.default.post(name: LDRNotificationCenter.didGetUnread, object: nil)
        }
    }

    /// request touch_all api
    func requestTouchAll() {
        LDRFeedOperationQueue.shared.requestTouchAll(subscribeId: self.subscribeId) { _, _ in }
    }

    /// returns title of unread feed at index
    ///
    /// - Parameter index: index of unread feed
    /// - Returns: title of unread feed or nil if not existed
    func getTitle(at index: Int) -> String? {
        if index < 0 {
            return nil
        }
        if index >= self.items.count {
            return nil
        }

        let item = self.items[index]
        return item["title"].stringValue
    }
    
    /// returns link of unread feed at index
    ///
    /// - Parameter index: index of unread feed
    /// - Returns: link of unread feed or nil if not existed
    func getLink(at index: Int) -> URL? {
        if index < 0 {
            return nil
        }
        if index >= self.items.count {
            return nil
        }

        let item = self.items[index]
        return URL(string: item["link"].stringValue)
    }

    /// returns body of unread feed at index
    ///
    /// - Parameter index: index of unread feed
    /// - Returns: body of unread feed
    func getBody(at index: Int) -> String? {
        if index < 0 {
            return nil
        }
        if index >= self.items.count {
            return nil
        }

        let item = self.items[index]
        return item["body"].stringValue
    }

}
