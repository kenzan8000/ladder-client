/// MARK: - LDRPinTableViewCell
class LDRPinTableViewCell: UITableViewCell {

    // MARK: - properties

    @IBOutlet weak var nameLabel: UILabel!


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
     * @return LDRPinTableViewCell
     **/
    class func ldr_cell() -> LDRPinTableViewCell {
        return UINib(nibName: LDRNSStringFromClass(LDRPinTableViewCell.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LDRPinTableViewCell
    }


    /// MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

