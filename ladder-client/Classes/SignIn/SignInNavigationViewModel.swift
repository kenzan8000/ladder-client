import Foundation

// MARK: - SignInNavigationViewModel

@Observable
final class SignInNavigationViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol

    private let service: any SignInServiceProtocol
    
    // MARK: - Public properties
    
    let signInViewModel: SignInViewModel

    // MARK: - Init
    
    init(keychain: any KeychainProtocol, service: any SignInServiceProtocol) {
        self.keychain = keychain
        self.service = service
        self.signInViewModel = SignInViewModel(keychain: keychain, service: service)
    }
}
