import Combine
import Foundation

// MARK: - RootSignInButtonViewModel

@Observable
final class RootSignInButtonViewModel {
    // MARK: - Private properties

    private let service: any SignInServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public properties
    
    private(set) var isSignedIn: Bool

    // MARK: - Init
    
    init(service: any SignInServiceProtocol) {
        self.service = service
        self.isSignedIn = service.isSignedIn
        service.isSignedInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (isSignedIn: Bool) in self?.isSignedIn = isSignedIn }
            .store(in: &self.cancellables)
    }
}
