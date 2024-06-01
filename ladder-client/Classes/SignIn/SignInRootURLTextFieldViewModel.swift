import Combine
import Foundation

// MARK: - SignInRootURLTextFieldViewModel

@Observable
final class SignInRootURLTextFieldViewModel {
    // MARK: - Private static methods
    
    private static func signUpURL(keychain: KeychainProtocol) -> URL? {
        guard let rootURLString = keychain.rootURL?.absoluteString else {
            return nil
        }
        return URLComponents(string: rootURLString + "/signup")?.url
    }
    
    private static func signUpLinkViewState(isValid: Bool, keychain: KeychainProtocol) -> SignUpLinkViewState {
        isValid ? .enabled(Self.signUpURL(keychain: keychain)) : .disabled
    }
    
    // MARK: - Private properties

    private var keychain: any KeychainProtocol

    private var rootURL: URL? { URL(string: scheme + domainAndPath) }
    
    private var isFocused = false

    private var hasAttemptedSigningIn = false
    
    private let isValidSubject: CurrentValueSubject<Bool, Never>
    
    private let signUpLinkViewStateSubject: CurrentValueSubject<SignUpLinkViewState, Never>

    // MARK: - Public properties

    /// Fastladder URL should always start with "https://" scheme
    let scheme: String = "https://"

    /// Input domain and path on the textfield
    var domainAndPath: String {
        didSet {
            keychain.rootURL = rootURL
            isValid = !domainAndPath.isEmpty
            updateState()
        }
    }
    
    /// State to define the text field design
    var state: SignInTextFieldState = .notFocused
    
    private(set) var isValid = false {
        didSet {
            isValidSubject.send(isValid)
            signUpLinkViewStateSubject.send(Self.signUpLinkViewState(isValid: isValid, keychain: keychain))
        }
    }
    
    let isValidPublisher: AnyPublisher<Bool, Never>

    let signUpLinkViewStatePublisher: AnyPublisher<SignUpLinkViewState, Never>

    // MARK: - Init

    init(keychain: any KeychainProtocol) {
        self.keychain = keychain

        let range = scheme.startIndex..<scheme.endIndex
        let rootURLString = keychain.rootURL?.absoluteString ?? ""
        let domainAndPath = rootURLString.starts(with: scheme) ? rootURLString.replacingCharacters(in: range, with: "") : ""
        self.domainAndPath = domainAndPath
        
        let isValid = !domainAndPath.isEmpty
        self.isValid = isValid
        
        let isVaildSubject = CurrentValueSubject<Bool, Never>(isValid)
        self.isValidSubject = isVaildSubject
        self.isValidPublisher = isValidSubject.eraseToAnyPublisher()
        let signUpLinkViewStateSubject = CurrentValueSubject<SignUpLinkViewState, Never>(Self.signUpLinkViewState(isValid: isValid, keychain: keychain))
        self.signUpLinkViewStateSubject = signUpLinkViewStateSubject
        self.signUpLinkViewStatePublisher = signUpLinkViewStateSubject.eraseToAnyPublisher()
    }

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
