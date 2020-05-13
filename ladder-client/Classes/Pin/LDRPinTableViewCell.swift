// MARK: - LDRPinTableViewCell
class LDRPinTableViewCell: UITableViewCell {

    // MARK: - properties

    @IBOutlet private weak var nameLabel: UILabel!

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
    class func ldr_cell() -> LDRPinTableViewCell? {
        UINib(
            nibName: LDRNSStringFromClass(LDRPinTableViewCell.self),
            bundle: nil
        ).instantiate(
            withOwner: nil,
            options: nil
        )[0] as? LDRPinTableViewCell
    }

    // MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - public api
    
    func setName(_ name: String) {
        self.nameLabel.text = name
    }
}
