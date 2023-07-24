import UIKit

// MARK: - LDRBlinkView
class LDRBlinkView: UIView {

    // MARK: properties

    var blinkCount = 1
    var blinkInterval = 0.08

    // MARK: class method

    /// show the blink view
    ///
    /// - Parameters:
    ///     - parentView: a view blink view is shown on
    ///     - color: color of blink
    ///     - count: number of blink
    ///     - interval: interval of blink
    class func show(on parentView: UIView, color: UIColor, count: Int, interval: Double) {
        let view = LDRBlinkView()
        view.frame = CGRect(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.height)
        view.backgroundColor = color
        view.blinkCount = count
        view.blinkInterval = interval
        parentView.addSubview(view)
        view.startBlinking()
    }

    // MARK: public api

    /// start animation
    func startBlinking() {
        blinkOn()
    }

    /// make blink on
    func blinkOn() {
        blinkCount -= 1
        alpha = 0.0
        UIView.animate(
            withDuration: blinkInterval,
            delay: 0.0,
            options: .curveEaseOut,
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.blinkOff() }
        )
    }

    /// make blink off
    func blinkOff() {
        alpha = 1.0
        UIView.animate(
            withDuration: blinkInterval,
            delay: 0.0,
            options: .curveEaseIn,
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in
                if let blinkCount = self?.blinkCount, blinkCount <= 0 {
                    self?.removeFromSuperview()
                } else {
                    self?.blinkOn()
                }
            }
        )
    }
}
