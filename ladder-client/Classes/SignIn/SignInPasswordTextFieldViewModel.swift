import Foundation

// MARK: - SignInPasswordTextFieldViewModel

class SignInPasswordTextFieldViewModel: ObservableObject {
    // MARK: - Public properties

    /// Input password on the textfield
    @Published var password = ""
}
