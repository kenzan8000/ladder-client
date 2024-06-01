import Combine
import Foundation

// MARK: - PinViewModel

final class PinViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    private let signInService: any SignInServiceProtocol
    
    // MARK: - Init
    
    init(
        keychain: any KeychainProtocol,
        signInService: any SignInServiceProtocol
    ) {
        self.keychain = keychain
        self.signInService = signInService
    }
    
    // MARK: - Public methods
    
    func makeRootNavigationViewModel() -> RootNavigationViewModel {
        RootNavigationViewModel(keychain: keychain, signInService: signInService)
    }
    
    func makeRootSignInViewModel() -> RootSignInViewModel {
        RootSignInViewModel(keychain: keychain, signInService: signInService)
    }
    
    func makePinListViewModel() -> PinListViewModel {
        PinListViewModel()
    }
}
