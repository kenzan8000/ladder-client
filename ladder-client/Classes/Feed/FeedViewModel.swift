import Foundation

// MARK: - FeedViewModel

@Observable
final class FeedViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    private let feedService: any FeedServiceProtocol
    
    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol,
        feedService: any FeedServiceProtocol
    ) {
        self.keychain = keychain
        self.signInService = signInService
        self.feedService = feedService
    }
    
    // MARK: - Public methods
    
    func makeRootNavigationViewModel() -> RootNavigationViewModel {
        RootNavigationViewModel(
            keychain: keychain,
            signInService: signInService,
            rootService: feedService
        )
    }
}
