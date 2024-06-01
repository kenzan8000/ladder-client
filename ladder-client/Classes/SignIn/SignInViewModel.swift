import Foundation

// MARK: - SignInViewModel

@Observable
final class SignInViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let service: any SignInServiceProtocol

    // MARK: - Public properties

    private(set) var rootURLTextFieldViewModel: SignInRootURLTextFieldViewModel

    private(set) var usernameTextFieldViewModel: SignInUsernameTextFieldViewModel

    private(set) var passwordTextFieldViewModel: SignInPasswordTextFieldViewModel

    private(set) var signInButtonViewModel: SignInButtonViewModel

    private(set) var signUpLinkViewModel: SignUpLinkViewModel

    var hasAttemptedSigningIn = false

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

    private(set) var error: Error?

    // MARK: - Init

    init(keychain: any KeychainProtocol, service: any SignInServiceProtocol) {
        self.keychain = keychain
        self.service = service
        let rootURLTextFieldViewModel = SignInRootURLTextFieldViewModel(keychain: keychain)
        let usernameTextFieldViewModel = SignInUsernameTextFieldViewModel()
        let passwordTextFieldViewModel = SignInPasswordTextFieldViewModel()
        self.rootURLTextFieldViewModel = rootURLTextFieldViewModel
        self.usernameTextFieldViewModel = usernameTextFieldViewModel
        self.passwordTextFieldViewModel = passwordTextFieldViewModel
        self.signInButtonViewModel = SignInButtonViewModel(
            isRootURLTextFieldValidPublisher: rootURLTextFieldViewModel.isValidPublisher,
            isUsernameTextFieldValidPublisher: usernameTextFieldViewModel.isValidPublisher,
            isPasswordTextFieldValidPublisher: passwordTextFieldViewModel.isValidPublisher,
            isSigningInPublisher: service.isSigningInPublisher
        )
        self.signUpLinkViewModel = SignUpLinkViewModel(publisher: rootURLTextFieldViewModel.signUpLinkViewStatePublisher)
    }

    // MARK: - Public methods

    @MainActor
    func signIn() async -> Bool {
        guard rootURLTextFieldViewModel.isValid,
        usernameTextFieldViewModel.isValid,
        passwordTextFieldViewModel.isValid,
        !service.isSigningIn else {
            return false
        }
        let hasSignedIn: Bool
        do {
            try await service.signIn(
                username: usernameTextFieldViewModel.username,
                password: passwordTextFieldViewModel.password
            )
            hasSignedIn = true
        } catch {
            self.error = error
            hasSignedIn = false
            service.signOut()
        }
        return hasSignedIn
    }

    func cancelSigningIn() {
        service.cancel()
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
