import Foundation

// MARK: - RootTabViewModel

class RootTabViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol, signInService: any SignInServiceProtocol) {
        self.keychain = keychain
        self.signInService = signInService
    }
    
    // MARK: - Public methods
    
    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(keychain: keychain, signInService: signInService)
    }
    
    func makePinViewModel() -> PinViewModel {
        PinViewModel(keychain: keychain, signInService: signInService)
    }
}
