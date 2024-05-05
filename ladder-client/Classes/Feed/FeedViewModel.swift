import Foundation

// MARK: - FeedViewModel

final class FeedViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol, signInService: any SignInServiceProtocol) {
        self.keychain = keychain
        self.signInService = signInService
    }
    
    // MARK: - Public methods
    
    func makeRootNavigationViewModel() -> RootNavigationViewModel {
        RootNavigationViewModel(keychain: keychain, signInService: signInService)
    }
}
