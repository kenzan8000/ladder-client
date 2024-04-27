import Foundation

// MARK: - RootTabViewModel

class RootTabViewModel: ObservableObject {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol
    
    // MARK: - Init
    
    init(keychain: any KeychainProtocol) {
        self.keychain = keychain
    }
    
    // MARK: - Public methods
    
    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(keychain: keychain)
    }
    
    func makePinViewModel() -> PinViewModel {
        PinViewModel(keychain: keychain)
    }
}
