// MARK: - LDRFeedTableViewCell
class LDRFeedTableViewCell: UITableViewCell {

    // MARK: - properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unreadCountLabel: UILabel!
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
        return 64.0
    }

    /// returns cell object
    ///
    /// - Returns: cell object
    class func ldr_cell() -> LDRFeedTableViewCell? {
        return UINib(nibName: LDRNSStringFromClass(LDRFeedTableViewCell.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? LDRFeedTableViewCell
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
        var color: UIColor? = nil
        if s == LDRFeedTableViewCell.State.unloaded {
            color = UIColor.systemGray4
        }
        else if s == LDRFeedTableViewCell.State.unread {
            color = UIColor.systemBlue
        }
        else if s == LDRFeedTableViewCell.State.read || s == LDRFeedTableViewCell.State.noUnread {
            color = UIColor.systemGray2
            self.unreadCountLabel.text = ""
        }

        if color != nil {
            self.nameLabel.textColor = color!
            self.unreadCountLabel.textColor = color!
        }
    }

}

