import Combine
import Foundation

// MARK: - RootNavigationViewModel

@Observable
final class RootNavigationViewModel {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol

    private let signInService: any SignInServiceProtocol
    
    private let rootService: any RootServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    
    var isSignInViewPresented = false
    
    private(set) var isSignedIn: Bool

    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol,
        rootService: any RootServiceProtocol
    ) {
        self.keychain = keychain
        self.signInService = signInService
        self.rootService = rootService
        self.isSignedIn = signInService.isSignedIn
        signInService.isSignedInPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (isSignedIn: Bool) in self?.isSignedIn = isSignedIn }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Public methods
    
    func makeSignInNavigationViewModel() -> SignInNavigationViewModel {
        SignInNavigationViewModel(keychain: keychain, service: signInService)
    }
    
    func makeRootSignInButtonViewModel() -> RootSignInButtonViewModel {
        RootSignInButtonViewModel(service: signInService)
    }
    
    func makeRootLoadButtonViewModel() -> RootLoadButtonViewModel {
        RootLoadButtonViewModel(service: rootService)
    }
    
    func signOut() {
        signInService.signOut()
    }
}
