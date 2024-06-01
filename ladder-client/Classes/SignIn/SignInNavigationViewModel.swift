import Foundation

// MARK: - SignInNavigationViewModel

@Observable
final class SignInNavigationViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol

    private let service: any SignInServiceProtocol

    // MARK: - Init
    
    init(keychain: any KeychainProtocol, service: any SignInServiceProtocol) {
        self.keychain = keychain
        self.service = service
    }
    
    // MARK: - Public methods
    
    func makeSignInViewModel() -> SignInViewModel {
        SignInViewModel(keychain: keychain, service: service)
    }
}
