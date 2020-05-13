import UIKit

// MARK: - LDRFeedViewForHeader
class LDRFeedViewForHeader: UIView {

    // MARK: - properties

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - class method

    /// returns view object
    ///
    /// - Returns: view object
    class func ldr_view() -> LDRFeedViewForHeader? {
        UINib(
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
    
    // MARK: - public apis
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
}
