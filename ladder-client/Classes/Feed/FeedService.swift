import Combine
import Foundation
import HTMLReader

// MARK: - FeedService

final class FeedService: FeedServiceProtocol {
    // MARK: - Private properties
    
    private let networking: any FeedNetworkingProtocol
    
    private let storage: any FeedStorageProtocol
    
    // MARK: - Public properties
    
    @Published private(set) var isLoading = false
    
    lazy var isLoadingPublisher: AnyPublisher<Bool, Never> = $isLoading.eraseToAnyPublisher()
    
    // MARK: - Init
    
    init(
        networking: any FeedNetworkingProtocol,
        storage: any FeedStorageProtocol
    ) {
        self.networking = networking
        self.storage = storage
    }
    
    // MARK: - Private methods
    
    private func resetStorage() {
        storage.set(feeds: [])
        storage.set(articleLists: [])
    }
    
    // MARK: - Public methods
    
    @MainActor
    func loadFeeds() async {
        isLoading = true
        do {
            let (data, _) = try await networking.feeds()
            let feeds = try JSONDecoder().decode([Feed].self, from: data)
            storage.set(feeds: feeds)
            for feed in feeds {
                let (data, _) = try await networking.unreadArticles(feedId: feed.id)
                let articleList = try JSONDecoder().decode(ArticleList.self, from: data)
                storage.add(articleList: articleList)
            }
        } catch {
            isLoading = false
            resetStorage()
            return
        }
        isLoading = false
    }
    
    @MainActor
    func cancel() {
        networking.cancel()
        isLoading = false
    }
    
    @MainActor
    func reload() {
        cancel()
        resetStorage()
        Task { @MainActor in
            await loadFeeds()
        }
    }
}
