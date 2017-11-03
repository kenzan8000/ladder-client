/// MARK: - LDRFeedUnread
class LDRFeedUnread {

    /// MARK: - property

    var subscribeId: String
    var items: [JSON]
    var state: Int


    /// MARK: - initialization

    /**
     * init
     * @param subscribeId String
     */
    init(subscribeId: String) {
        self.subscribeId = subscribeId
        self.items = []
        self.state = LDRFeedTableViewCell.state.unloaded
    }


    /// MARK: - public api

    /**
     * request unread
     **/
    func request() {
        LDRFeedOperationQueue.shared.requestUnread(
            subscribeId: self.subscribeId,
            completionHandler: { [unowned self] (json: JSON?, error: Error?) -> Void in
                if json != nil && json!["items"] != nil { self.items = json!["items"].arrayValue }
                if self.items.count == 0 { self.state = LDRFeedTableViewCell.state.noUnread }
                else { self.state = LDRFeedTableViewCell.state.unread }
                NotificationCenter.default.post(name: LDRNotificationCenter.didGetUnread, object: nil)
            }
        )
    }
}
