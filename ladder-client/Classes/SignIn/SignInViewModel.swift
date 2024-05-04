import Foundation

// MARK: - SignInViewModel

class SignInViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private var hasAttemptedSigningIn = false

    // MARK: - Public properties
    
    private(set) lazy var rootURLTextFieldViewModel = SignInRootURLTextFieldViewModel(keychain: keychain)
    
    private(set) lazy var usernameTextFieldViewModel = SignInUsernameTextFieldViewModel()
    
    private(set) lazy var passwordTextFieldViewModel = SignInPasswordTextFieldViewModel()
    
    private(set) lazy var buttonViewModel = SignInButtonViewModel()

    var nextFocusedField: SignInView.Field? {
        guard rootURLTextFieldViewModel.isValid else {
            return .rootURL
        }
        guard usernameTextFieldViewModel.isValid else {
            return .username
        }
        guard passwordTextFieldViewModel.isValid else {
            return .password
        }
        return .none
    }
    
    @Published private(set) var isSigningIn = false
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol) {
        self.keychain = keychain
    }
    
    // MARK: - Public methods
    
    func signIn() {
        hasAttemptedSigningIn = true
        guard rootURLTextFieldViewModel.isValid,
        usernameTextFieldViewModel.isValid,
        passwordTextFieldViewModel.isValid,
        !isSigningIn else {
            return
        }
        isSigningIn = true
    }
    
    func cancelSigningIn() {
    }
    
    func updateState(focusedField: SignInView.Field?) {
        rootURLTextFieldViewModel.updateState(
            isFocused: focusedField == .rootURL,
            hasAttemptedSigningIn: hasAttemptedSigningIn
        )
        usernameTextFieldViewModel.updateState(
            isFocused: focusedField == .username,
            hasAttemptedSigningIn: hasAttemptedSigningIn
        )
        passwordTextFieldViewModel.updateState(
            isFocused: focusedField == .password,
            hasAttemptedSigningIn: hasAttemptedSigningIn
        )
    }
}
