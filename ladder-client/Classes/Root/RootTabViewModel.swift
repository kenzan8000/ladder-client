import Foundation

// MARK: - RootTabViewModel

@Observable
final class RootTabViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    private let feedService: any FeedServiceProtocol
    
    private let feedStorage: any FeedStorageProtocol
    
    private let pinService: any PinServiceProtocol
    
    private let pinStorage: any PinStorageProtocol
    
    // MARK: - Public properties

    var selectedTab: RootTabView.Tab
    
    let feedViewModel: FeedViewModel
    
    let pinViewModel: PinViewModel

    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol,
        feedService: any FeedServiceProtocol,
        feedStorage: any FeedStorageProtocol,
        pinService: any PinServiceProtocol,
        pinStorage: any PinStorageProtocol,
        selectedTab: RootTabView.Tab = .feeds
    ) {
        self.keychain = keychain
        self.signInService = signInService
        self.feedService = feedService
        self.feedStorage = feedStorage
        self.pinService = pinService
        self.pinStorage = pinStorage
        self.selectedTab = selectedTab
        self.feedViewModel = FeedViewModel(
            keychain: keychain,
            signInService: signInService,
            feedService: feedService,
            feedStorage: feedStorage,
            pinService: pinService
        )
        self.pinViewModel = PinViewModel(
            keychain: keychain,
            signInService: signInService,
            pinService: pinService,
            pinStorage: pinStorage
        )
    }
}
