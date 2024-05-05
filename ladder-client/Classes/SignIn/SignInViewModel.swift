import Combine
import Foundation

// MARK: - SignInViewModel

class SignInViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let service: any SignInServiceProtocol

    @Published private var isSigningIn = false
    
    private lazy var buttonViewStatePublisher: AnyPublisher<SignInButtonViewState, Never> = {
        let isFormValid: AnyPublisher<Bool, Never> = Publishers.CombineLatest3(
            rootURLTextFieldViewModel.$isValid.eraseToAnyPublisher(),
            usernameTextFieldViewModel.$isValid.eraseToAnyPublisher(),
            passwordTextFieldViewModel.$isValid.eraseToAnyPublisher()
        ).map { v1, v2, v3 -> Bool in
            v1 && v2 && v3
        }.eraseToAnyPublisher()
        return Publishers.CombineLatest(
            $isSigningIn.eraseToAnyPublisher(),
            isFormValid
        ).map { isSigningIn, isFormValid -> SignInButtonViewState in
            guard !isSigningIn else {
                return .loading
            }
            return isFormValid ? .signIn : .invaildForm
        }.eraseToAnyPublisher()
    }()

    // MARK: - Public properties

    private(set) lazy var rootURLTextFieldViewModel = SignInRootURLTextFieldViewModel(keychain: keychain)

    private(set) lazy var usernameTextFieldViewModel = SignInUsernameTextFieldViewModel()

    private(set) lazy var passwordTextFieldViewModel = SignInPasswordTextFieldViewModel()

    private(set) lazy var buttonViewModel = SignInButtonViewModel(statePublisher: buttonViewStatePublisher)

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

    @Published private(set) var error: Error?

    // MARK: - Init

    init(keychain: any KeychainProtocol, service: any SignInServiceProtocol) {
        self.keychain = keychain
        self.service = service
    }

    // MARK: - Public methods

    @MainActor
    func signIn() async -> Bool {
        guard rootURLTextFieldViewModel.isValid,
        usernameTextFieldViewModel.isValid,
        passwordTextFieldViewModel.isValid,
        !isSigningIn else {
            return false
        }
        isSigningIn = true
        let hasSignedIn: Bool
        do {
            try await service.signIn(username: usernameTextFieldViewModel.username, password: passwordTextFieldViewModel.password)
            hasSignedIn = true
        } catch {
            self.error = error
            hasSignedIn = false
        }
        isSigningIn = false
        return hasSignedIn
    }

    func cancelSigningIn() {
        service.cancel()
        isSigningIn = false
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
