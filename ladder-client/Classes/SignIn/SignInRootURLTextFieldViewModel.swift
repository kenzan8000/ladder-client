import Combine
import Foundation

// MARK: - SignInRootURLTextFieldViewModel

class SignInRootURLTextFieldViewModel: ObservableObject {
    // MARK: - Private properties

    private var keychain: any KeychainProtocol

    private var rootURL: URL? { URL(string: scheme + domainAndPath) }
    
    private var isFocused = false
    
    private var hasAttemptedSigningIn = false

    // MARK: - Public properties

    /// Fastladder URL should always start with "https://" scheme
    let scheme: String = "https://"

    /// Input domain and path on the textfield
    @Published var domainAndPath: String {
        didSet {
            keychain.rootURL = rootURL
            isValid = !domainAndPath.isEmpty
            updateState()
        }
    }

    /// Is the input Fastladder URL valid?
    @Published private(set) var isValid = false

    /// State to define the text field design
    @Published private(set) var state: SignInTextFieldState = .notFocused

    // MARK: - Init

    init(keychain: any KeychainProtocol) {
        self.keychain = keychain

        let range = scheme.startIndex..<scheme.endIndex
        let rootURLString = keychain.rootURL?.absoluteString ?? ""
        self.domainAndPath = rootURLString.starts(with: scheme) ? rootURLString.replacingCharacters(in: range, with: "") : ""
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
