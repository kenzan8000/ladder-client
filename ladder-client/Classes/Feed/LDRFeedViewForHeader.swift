import UIKit

// MARK: - LDRFeedViewForHeader
class LDRFeedViewForHeader: UIView {

    // MARK: - properties

    @IBOutlet weak var titleLabel: UILabel!


    // MARK: - class method

    /// returns view object
    ///
    /// - Returns: view object
    class func ldr_view() -> LDRFeedViewForHeader? {
        return UINib(
            nibName: LDRNSStringFromClass(LDRFeedViewForHeader.self),
            bundle: nil
        ).instantiate(
            withOwner: nil,
            options: nil
        )[0] as? LDRFeedViewForHeader
    }


    // MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

