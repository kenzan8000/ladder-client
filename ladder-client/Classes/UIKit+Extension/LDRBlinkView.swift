// MARK: - LDRBlinkView
class LDRBlinkView: UIView {

    // MARK: - properties

    var blinkCount = 1
    var blinkInterval = 0.08

    // MARK: - class method

    /// show the blink view
    ///
    /// - Parameters:
    ///   - on: a view blink view is shown on
    ///   - color: color of blink
    ///   - count: number of blink
    ///   - interval: interval of blink
    class func show(on: UIView, color: UIColor, count: Int, interval: Double) {
        let view = LDRBlinkView()
        view.frame = CGRect(x: 0, y: 0, width: on.frame.width, height: on.frame.height)
        view.backgroundColor = color
        view.blinkCount = count
        view.blinkInterval = interval

        on.addSubview(view)

        view.startBlinking()
    }

    // MARK: - public api

    /// start animation
    func startBlinking() {
        self.blinkOn()
    }

    /// make blink on
    func blinkOn() {
        self.blinkCount -= 1
        self.alpha = 0.0

        UIView.animate(
            withDuration: self.blinkInterval,
            delay: 0.0,
            options: .curveEaseOut,
            animations: { [unowned self] in
                self.alpha = 1.0
            },
            completion: { [unowned self] _ in
                self.blinkOff()
            }
        )
    }

    /// make blink off
    func blinkOff() {
        self.alpha = 1.0

        UIView.animate(
            withDuration: self.blinkInterval,
            delay: 0.0,
            options: .curveEaseIn,
            animations: { [unowned self] in
                self.alpha = 0.0
            },
            completion: { [unowned self] _ in
                if self.blinkCount <= 0 {
                    self.removeFromSuperview()
                } else {
                    self.blinkOn()
                }
            }
        )
    }

}
