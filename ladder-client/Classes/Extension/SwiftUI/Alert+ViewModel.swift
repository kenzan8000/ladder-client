import SwiftUI

// MARK: - Alert + ViewModel
extension Alert {
    struct ViewModel: Identifiable {
        let title: String
        let message: String
        let buttonText: String
        let buttonAction: (() -> Void)?
        var id: String { title + message + buttonText }
    }
}
