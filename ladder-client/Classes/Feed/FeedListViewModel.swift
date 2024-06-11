import Combine
import Foundation

// MARK: - FeedListViewModel

@Observable
final class FeedListViewModel {
    // MARK: - Private properties
    
    private let service: any FeedServiceProtocol
    
    private let storage: any FeedStorageProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    
    private(set) var feeds: [Feed] = []
    
    // MARK: - Init
    
    init(
        service: any FeedServiceProtocol,
        storage: any FeedStorageProtocol
    ) {
        self.service = service
        self.storage = storage
        storage.get()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (feeds: [Feed]) in self?.feeds = feeds }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Public methods
    
    @MainActor
    func loadFeeds() async {
        guard !service.isLoading else {
            return
        }
        await service.loadFeeds()
    }
}
