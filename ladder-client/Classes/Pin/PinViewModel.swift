import Combine
import Foundation

// MARK: - PinViewModel

@Observable
final class PinViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    private let pinService: any PinServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    
    private(set) var isSignedIn: Bool
    
    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol,
        pinService: any PinServiceProtocol
    ) {
        self.keychain = keychain
        self.signInService = signInService
        self.pinService = pinService
        self.isSignedIn = signInService.isSigningIn
        signInService.isSignedInPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (isSignedIn: Bool) in self?.isSignedIn = isSignedIn }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Public methods
    
    func makeRootNavigationViewModel() -> RootNavigationViewModel {
        RootNavigationViewModel(keychain: keychain, signInService: signInService)
    }
    
    func makeRootSignInViewModel() -> RootSignInViewModel {
        RootSignInViewModel(keychain: keychain, signInService: signInService)
    }
    
    func makePinListViewModel() -> PinListViewModel {
        PinListViewModel(service: pinService)
    }
}
