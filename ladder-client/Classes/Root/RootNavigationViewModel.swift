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
    
    let signInNavigationViewModel: SignInNavigationViewModel
    
    let rootSignInButtonViewModel: RootSignInButtonViewModel
    
    let rootLoadButtonViewModel: RootLoadButtonViewModel
    
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
        self.signInNavigationViewModel = SignInNavigationViewModel(keychain: keychain, service: signInService)
        self.rootSignInButtonViewModel = RootSignInButtonViewModel(service: signInService)
        self.rootLoadButtonViewModel = RootLoadButtonViewModel(service: rootService)
        signInService.isSignedInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (isSignedIn: Bool) in self?.isSignedIn = isSignedIn }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Public methods
    
    func signOut() {
        signInService.signOut()
    }
}
