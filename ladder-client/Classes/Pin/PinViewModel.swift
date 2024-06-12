import Combine
import Foundation

// MARK: - PinViewModel

@Observable
final class PinViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    private let pinService: any PinServiceProtocol
    
    private let pinStorage: any PinStorageProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    
    private(set) var isSignedIn: Bool {
        didSet {
            let didSignIn = !oldValue && isSignedIn
            if didSignIn {
                pinService.reload()
            }
            let didSignOut = oldValue && !isSignedIn
            if didSignOut {
                pinService.cancel()
                pinStorage.set(pins: [])
            }
        }
    }
    
    let rootNavigationViewModel: RootNavigationViewModel
    
    let rootSignInViewModel: RootSignInViewModel
    
    let pinListViewModel: PinListViewModel
    
    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol,
        pinService: any PinServiceProtocol,
        pinStorage: any PinStorageProtocol
    ) {
        self.keychain = keychain
        self.signInService = signInService
        self.pinService = pinService
        self.pinStorage = pinStorage
        self.isSignedIn = signInService.isSigningIn
        self.rootNavigationViewModel = RootNavigationViewModel(
            keychain: keychain,
            signInService: signInService,
            rootService: pinService
        )
        self.rootSignInViewModel = RootSignInViewModel(keychain: keychain, signInService: signInService)
        self.pinListViewModel = PinListViewModel(service: pinService, storage: pinStorage)
        signInService.isSignedInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (isSignedIn: Bool) in self?.isSignedIn = isSignedIn }
            .store(in: &self.cancellables)
    }
}
