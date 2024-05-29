import Combine
import Foundation

// MARK: - RootSignInButtonViewModel

final class RootSignInButtonViewModel: ObservableObject {
    // MARK: - Private properties

    private let service: any SignInServiceProtocol
    
    // MARK: - Public properties
    
    lazy var isSignedInPublisher: AnyPublisher<Bool, Never> = service.isSignedInPublisher

    // MARK: - Init
    
    init(service: any SignInServiceProtocol) {
        self.service = service
    }
}
