import SwiftyJSON

// MARK: - LDRFeedUnread
class LDRFeedUnread {
    
    // MARK: - enum
    
    enum State: Int {
        case unloaded = 0
        case unread = 1
        case read = 2
        case noUnread = 3
    }
    
    // MARK: - property

    var subscribeId: String
    var title: String
    var items: [JSON]
    var state: State
    var requestCount: Int {
        LDRFeedOperationQueue.shared.operations.count
    }

    // MARK: - initialization

    /// initializer
    ///
    /// - Parameter subscribeId: subscribe id
    ///   - title: title of feed
    init(subscribeId: String, title: String) {
        self.subscribeId = subscribeId
        self.title = title
        self.items = []
        self.state = .unloaded
    }

    // MARK: - public api

    /// request unread api
    func request(
        completionHandler: @escaping (_ unread: LDRFeedUnread) -> Void
    ) {
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
            completionHandler(self)
        }
    }

    /// request touch_all api
    func requestTouchAll() {
        if state == State.unread {
            state = State.read
        }
        LDRFeedOperationQueue.shared.requestTouchAll(subscribeId: subscribeId) { _, _ in }
    }

    /// returns title of unread feed at index
    ///
    /// - Parameter index: index of unread feed
    /// - Returns: title of unread feed or nil if not existed
    func getTitle(at index: Int) -> String? {
        if index < 0 {
            return nil
        }
        if index >= items.count {
            return nil
        }

        let item = items[index]
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

        let item = items[index]
        return item["body"].stringValue
    }

}
