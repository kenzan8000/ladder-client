/// MARK: - LDRPinTableViewCell
class LDRPinTableViewCell: UITableViewCell {

    // MARK: - properties

    @IBOutlet weak var nameLabel: UILabel!


    /// MARK: - class method
    
    /// returns cell height
    ///
    /// - Returns: cell height
    class func ldr_height() -> CGFloat {
        return 64.0
    }
    
    /// returns cell object
    ///
    /// - Returns: cell object
    class func ldr_cell() -> LDRPinTableViewCell {
        return UINib(
            nibName: LDRNSStringFromClass(LDRPinTableViewCell.self),
            bundle: nil
        ).instantiate(
            withOwner: nil,
            options: nil
        )[0] as! LDRPinTableViewCell
    }


    /// MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

