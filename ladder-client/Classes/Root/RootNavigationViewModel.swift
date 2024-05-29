import Combine
import Foundation

// MARK: - RootNavigationViewModel

final class RootNavigationViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol

    private let signInService: any SignInServiceProtocol
    
    // MARK: - Public properties
    
    lazy var isSignedInPublisher: AnyPublisher<Bool, Never> = signInService.isSignedInPublisher

    // MARK: - Init
    
    init(keychain: any KeychainProtocol, signInService: any SignInServiceProtocol) {
        self.keychain = keychain
        self.signInService = signInService
    }
    
    // MARK: - Public methods
    
    func makeSignInNavigationViewModel() -> SignInNavigationViewModel {
        SignInNavigationViewModel(keychain: keychain, service: signInService)
    }
    
    func makeRootSignInButtonViewModel() -> RootSignInButtonViewModel {
        RootSignInButtonViewModel(service: signInService)
    }
    
    func signOut() {
        signInService.signOut()
    }
}
