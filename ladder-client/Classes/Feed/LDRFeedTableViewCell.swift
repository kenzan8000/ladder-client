// MARK: - LDRFeedTableViewCell
class LDRFeedTableViewCell: UITableViewCell {

    // MARK: - properties

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var unreadCountLabel: UILabel!
    enum State {
        static let unloaded = 0
        static let unread = 1
        static let read = 2
        static let noUnread = 3
    }

    // MARK: - class method
    
    /// returns cell height
    ///
    /// - Returns: cell height
    class func ldr_height() -> CGFloat {
        64.0
    }

    /// returns cell object
    ///
    /// - Returns: cell object
    class func ldr_cell() -> LDRFeedTableViewCell? {
        UINib(
            nibName: LDRNSStringFromClass(LDRFeedTableViewCell.self), bundle: nil
        ).instantiate(
            withOwner: nil,
            options: nil
        )[0] as? LDRFeedTableViewCell
    }

    // MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - public api

    /**
     * set ui state
     * @param state Int
     **/
    
    /// set ui state (unloaded, unread, read)
    ///
    /// - Parameter s: state (unloaded, unread, read)
    func setUIState(_ s: Int) {
        var color: UIColor?
        if s == LDRFeedTableViewCell.State.unloaded {
            color = UIColor.systemGray4
        } else if s == LDRFeedTableViewCell.State.unread {
            color = UIColor.systemBlue
        } else if s == LDRFeedTableViewCell.State.read || s == LDRFeedTableViewCell.State.noUnread {
            color = UIColor.systemGray2
            self.unreadCountLabel.text = ""
        }

        if let c = color {
            self.nameLabel.textColor = c
            self.unreadCountLabel.textColor = c
        }
    }

    /// Set text of nameLabel and unreadLabel
    ///
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - unreadCount: <#unreadCount description#>
    func setTexts(name: String, unreadCount: String) {
        self.nameLabel.text = name
        self.unreadCountLabel.text = unreadCount
    }
}
