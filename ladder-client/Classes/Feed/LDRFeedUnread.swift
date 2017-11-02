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

}
