import UIKit

// MARK: - BlinkView
class BlinkView: UIView {

    // MARK: Public methods
    
    func startAnimating(on view: UIView) {
        frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundColor = .systemGray6.withAlphaComponent(0.5)
        view.addSubview(self)
        blinkOn()
    }

    func blinkOn() {
        alpha = 0.0
        UIView.animate(
            withDuration: 0.08,
            delay: 0.0,
            options: .curveEaseOut,
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.blinkOff() }
        )
    }

    func blinkOff() {
        alpha = 1.0
        UIView.animate(
            withDuration: 0.08,
            delay: 0.0,
            options: .curveEaseIn,
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] (completed: Bool) in
                guard completed else {
                    return
                }
                self?.removeFromSuperview()
            }
        )
    }
}
