import Combine
import Foundation

// MARK: - RootLoadButtonViewModel

@Observable
final class RootLoadButtonViewModel {
    // MARK: - Private properties
    
    private let service: any RootServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    
    private(set) var isLoading: Bool
    
    // MARK: - Init
    
    init(service: any RootServiceProtocol) {
        self.service = service
        self.isLoading = service.isLoading
        service.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (isLoading: Bool) in self?.isLoading = isLoading }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Public methods
    
    func reload() {
        service.reload()
    }
}
