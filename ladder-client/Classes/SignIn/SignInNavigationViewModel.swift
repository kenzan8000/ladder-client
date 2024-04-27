import Foundation

// MARK: - SignInNavigationViewModel

class SignInNavigationViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol) {
        self.keychain = keychain
    }
    
    // MARK: - Public methods
    
    func makeSignInViewModel() -> SignInViewModel {
        SignInViewModel(keychain: keychain)
    }
}
