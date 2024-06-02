import Foundation

// MARK: - RootTabViewModel

@Observable
final class RootTabViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    private let pinService: any PinServiceProtocol
    
    // MARK: - Public properties

    var selectedTab: RootTabView.Tab

    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol,
        pinService: any PinServiceProtocol,
        selectedTab: RootTabView.Tab = .feeds
    ) {
        self.keychain = keychain
        self.signInService = signInService
        self.pinService = pinService
        self.selectedTab = selectedTab
    }
    
    // MARK: - Public methods
    
    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(keychain: keychain, signInService: signInService)
    }
    
    func makePinViewModel() -> PinViewModel {
        PinViewModel(keychain: keychain, signInService: signInService, pinService: pinService)
    }
}
