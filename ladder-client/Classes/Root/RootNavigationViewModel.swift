import Foundation

// MARK: - RootNavigationViewModel

class RootNavigationViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol) {
        self.keychain = keychain
    }
    
    // MARK: - Public methods
    
    func makeSignInNavigationViewModel() -> SignInNavigationViewModel {
        SignInNavigationViewModel(keychain: keychain)
    }
}
