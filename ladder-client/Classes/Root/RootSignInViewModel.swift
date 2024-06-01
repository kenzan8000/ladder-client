import Foundation

// MARK: - RootSignInViewModel

@Observable
final class RootSignInViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol

    private let signInService: any SignInServiceProtocol
    
    // MARK: - Public properties
    
    var isSignInViewPresented = false

    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol
    ) {
        self.keychain = keychain
        self.signInService = signInService
    }
    
    // MARK: - Public methods
    
    func makeSignInNavigationViewModel() -> SignInNavigationViewModel {
        SignInNavigationViewModel(keychain: keychain, service: signInService)
    }
}
