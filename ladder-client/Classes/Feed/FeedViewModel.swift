import Combine
import Foundation

// MARK: - FeedViewModel

@Observable
final class FeedViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    private let feedService: any FeedServiceProtocol
    
    private let feedStorage: any FeedStorageProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    
    private(set) var isSignedIn: Bool {
        didSet {
            let didSignIn = !oldValue && isSignedIn
            if didSignIn {
                feedService.reload()
            }
            let didSignOut = oldValue && !isSignedIn
            if didSignOut {
                feedService.cancel()
                feedStorage.set(feeds: [])
            }
        }
    }
    
    let rootNavigationViewModel: RootNavigationViewModel
    
    let rootSignInViewModel: RootSignInViewModel
    
    let feedListViewModel: FeedListViewModel
    
    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol,
        feedService: any FeedServiceProtocol,
        feedStorage: any FeedStorageProtocol
    ) {
        self.keychain = keychain
        self.signInService = signInService
        self.feedService = feedService
        self.feedStorage = feedStorage
        self.isSignedIn = signInService.isSigningIn
        self.rootNavigationViewModel = RootNavigationViewModel(
            keychain: keychain,
            signInService: signInService,
            rootService: feedService
        )
        self.rootSignInViewModel = RootSignInViewModel(keychain: keychain, signInService: signInService)
        self.feedListViewModel = FeedListViewModel(service: feedService, storage: feedStorage)
        signInService.isSignedInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (isSignedIn: Bool) in self?.isSignedIn = isSignedIn }
            .store(in: &self.cancellables)
    }
}
