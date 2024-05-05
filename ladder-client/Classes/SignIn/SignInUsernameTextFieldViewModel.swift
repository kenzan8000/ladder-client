import Foundation

// MARK: - SignInUsernameTextFieldViewModel

class SignInUsernameTextFieldViewModel: ObservableObject {
    // MARK: - Private properties
    
    private var isFocused = false
    
    private var hasAttemptedSigningIn = false

    // MARK: - Public properties

    /// Input username on the textfield
    @Published var username = "" {
        didSet {
            isValid = !username.isEmpty
            updateState()
        }
    }

    /// Is the input username valid?
    @Published var isValid = false

    /// State to define the text field design
    @Published private(set) var state: SignInTextFieldState = .notFocused

    // MARK: - Private methods

    private func updateState() {
        let shouldShowError = hasAttemptedSigningIn && !isValid
        if shouldShowError {
            state = .error
        } else {
            state = isFocused ? .focused : .notFocused
        }
    }

    // MARK: - Public methods

    func updateState(isFocused: Bool, hasAttemptedSigningIn: Bool) {
        self.isFocused = isFocused
        self.hasAttemptedSigningIn = hasAttemptedSigningIn
        updateState()
    }
}
