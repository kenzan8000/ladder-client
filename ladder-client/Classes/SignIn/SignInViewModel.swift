import Foundation

// MARK: - SignInViewModel

class SignInViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol

    // MARK: - Public properties
    
    private(set) lazy var rootURLTextFieldViewModel = SignInRootURLTextFieldViewModel(keychain: keychain)
    
    private(set) lazy var usernameTextFieldViewModel = SignInUsernameTextFieldViewModel()
    
    private(set) lazy var passwordTextFieldViewModel = SignInPasswordTextFieldViewModel()
    
    private(set) lazy var buttonViewModel = SignInButtonViewModel()

    var nextFocusedField: SignInView.Field? {
        guard rootURLTextFieldViewModel.isURLValid else {
            return .rootURL
        }
        guard usernameTextFieldViewModel.isUsernameValid else {
            return .username
        }
        guard passwordTextFieldViewModel.isPasswordValid else {
            return .password
        }
        return nil
    }
    
    var isFormValid: Bool {
        rootURLTextFieldViewModel.isURLValid &&
        usernameTextFieldViewModel.isUsernameValid &&
        passwordTextFieldViewModel.isPasswordValid
    }
    
    private(set) var isSigningIn = false
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol) {
        self.keychain = keychain
    }
    
    // MARK: - Public methods
    
    func signIn() {
        guard !isSigningIn else {
            return
        }
    }
    
    func cancelSigningIn() {
    }
}
