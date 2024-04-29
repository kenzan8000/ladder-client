import Foundation

// MARK: - SignInUsernameTextFieldViewModel

class SignInUsernameTextFieldViewModel: ObservableObject {
    // MARK: - Public properties

    /// Input username on the textfield
    @Published var username = ""
    
    /// Is the input username valid?
    var isUsernameValid: Bool { !username.isEmpty }
}
