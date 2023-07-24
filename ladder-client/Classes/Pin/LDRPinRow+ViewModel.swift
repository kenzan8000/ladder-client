import SwiftUI

// MARK: - LDRPinRow + ViewModel
extension LDRPinRow {
    // MARK: ViewModel
    struct ViewModel {
        let pin: Pin
        var title: String {
            pin.title
        }
    }
}
