import Foundation

// MARK: - SignInRootURLTextFieldViewModel

class SignInRootURLTextFieldViewModel: ObservableObject {
    // MARK: - Private properties

    private var keychain: any KeychainProtocol

    // MARK: - Public properties
    
    /// Fastladder URL should always start with "https://" scheme
    let scheme: String = "https://"

    /// Input domain and path on the textfield
    @Published var domainAndPath: String {
        didSet {
            keychain.rootURL = URL(string: scheme + domainAndPath)
        }
    }
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol) {
        self.keychain = keychain

        let range = scheme.startIndex..<scheme.endIndex
        let rootURLString = keychain.rootURL?.absoluteString ?? ""
        self.domainAndPath = rootURLString.starts(with: scheme) ? rootURLString.replacingCharacters(in: range, with: "") : ""
    }
}
