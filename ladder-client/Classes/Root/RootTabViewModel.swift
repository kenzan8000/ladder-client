import Foundation

// MARK: - RootTabViewModel

@Observable
final class RootTabViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    private let feedService: any FeedServiceProtocol
    
    private let pinService: any PinServiceProtocol
    
    // MARK: - Public properties

    var selectedTab: RootTabView.Tab

    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol,
        feedService: any FeedServiceProtocol,
        pinService: any PinServiceProtocol,
        selectedTab: RootTabView.Tab = .feeds
    ) {
        self.keychain = keychain
        self.signInService = signInService
        self.feedService = feedService
        self.pinService = pinService
        self.selectedTab = selectedTab
    }
    
    // MARK: - Public methods
    
    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(
            keychain: keychain,
            signInService: signInService,
            feedService: feedService
        )
    }
    
    func makePinViewModel() -> PinViewModel {
        PinViewModel(
            keychain: keychain,
            signInService: signInService,
            pinService: pinService
        )
    }
}
