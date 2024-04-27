import Foundation

// MARK: - PinViewModel

class PinViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol) {
        self.keychain = keychain
    }
    
    // MARK: - Public methods
    
    func makeRootNavigationViewModel() -> RootNavigationViewModel {
        RootNavigationViewModel(keychain: keychain)
    }
}
