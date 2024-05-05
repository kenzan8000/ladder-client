import Foundation

// MARK: - SignInPasswordTextFieldViewModel

class SignInPasswordTextFieldViewModel: ObservableObject {
    // MARK: - Private properties
    
    private var isFocused = false
    
    private var hasAttemptedSigningIn = false

    // MARK: - Public properties

    /// Input password on the textfield
    @Published var password = "" {
        didSet {
            isValid = !password.isEmpty
            updateState()
        }
    }

    /// Is the input password valid?
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
