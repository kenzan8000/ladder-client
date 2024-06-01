import Combine
import Foundation

// MARK: - RootSignInButtonViewModel

@Observable
final class RootSignInButtonViewModel {
    // MARK: - Private properties

    private let service: any SignInServiceProtocol
    
    // MARK: - Public properties
    
    var isSignedInPublisher: AnyPublisher<Bool, Never>

    // MARK: - Init
    
    init(service: any SignInServiceProtocol) {
        self.service = service
        self.isSignedInPublisher = service.isSignedInPublisher
    }
}
