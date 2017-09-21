/// MARK: - LDRFeedTableViewCell
class LDRFeedTableViewCell: UITableViewCell {

    // MARK: - properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unreadCountLabel: UILabel!


    /// MARK: - class method

    /**
     * return cell height
     * @return CGFloat
     **/
    class func ldr_height() -> CGFloat {
        return 64.0
    }

    /**
     * get cell
     * @return LDRFeedTableViewCell
     **/
    class func ldr_cell() -> LDRFeedTableViewCell {
        return UINib(nibName: LDRNSStringFromClass(LDRFeedTableViewCell.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LDRFeedTableViewCell
    }


    /// MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

