import Foundation

// MARK: - SignInViewModel

class SignInViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol) {
        self.keychain = keychain
    }
    
    // MARK: - Public methods
    
    func makeSignInRootURLTextFieldViewModel() -> SignInRootURLTextFieldViewModel {
        SignInRootURLTextFieldViewModel(keychain: keychain)
    }
}
