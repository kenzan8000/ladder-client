import UIKit

// MARK: - LDRToastView
class LDRToastView: UILabel {

    // MARK: - properties
    
    var appearingDuration = 0.2
    var displayDuration = 1.5
    var disappearingDuration = 0.15

    // MARK: - class method

    /// show toast
    ///
    /// - Parameters:
    ///   - parentView: view toast is shown on
    ///   - text: text displayed on
    class func show(
        on parentView: UIView,
        text: String
    ) {
        let minMarginX = CGFloat(20.0)
        let padding = CGFloat(10.0)
        let cornerRadius = CGFloat(20.0)
        
        let view = LDRToastView()
        view.text = text
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label
        view.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.85)
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: parentView.frame.width - minMarginX * 2.0,
            height: 0
        )
        view.sizeToFit()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width + padding * 2.0,
            height: view.frame.height + padding * 2.0
        )
        view.center = parentView.center
        parentView.addSubview(view)
        
        view.start()
    }

    // MARK: - public api

    /// start animation
    func start() {
        appear()
    }
    
    /// appear with animation
    func appear() {
        alpha = 0.0

        UIView.animate(
            withDuration: appearingDuration,
            delay: 0.0,
            options: .curveEaseOut,
            animations: { [unowned self] in
                self.alpha = 1.0
            },
            completion: { [unowned self] _ in
                self.disappear()
            }
        )
    }
    
    /// disappear with animation
    func disappear() {
        alpha = 1.0

        UIView.animate(
            withDuration: disappearingDuration,
            delay: displayDuration,
            options: .curveEaseIn,
            animations: { [unowned self] in
                self.alpha = 0.0
            },
            completion: { [unowned self] _ in
                self.removeFromSuperview()
            }
        )
    }

}
