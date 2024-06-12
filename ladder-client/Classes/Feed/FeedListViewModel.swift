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
    
    private(set) var articleFeeds: [ArticleFeed] = []
    
    var selectedArticleFeed: ArticleFeed?
    
    // MARK: - Init
    
    init(
        service: any FeedServiceProtocol,
        storage: any FeedStorageProtocol
    ) {
        self.service = service
        self.storage = storage
        storage.getArticleFeeds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (articleFeeds: [ArticleFeed]) in
                self?.articleFeeds = articleFeeds
            }
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
    
    func setSelectedArticleFeedIfNeeded(_ articleFeed: ArticleFeed) {
        guard !articleFeed.articles.isEmpty else {
            return
        }
        selectedArticleFeed = articleFeed
    }
    
    func makeArticleListViewModel(articles: [Article]) -> ArticleListViewModel {
        ArticleListViewModel(articles: articles)
    }
}
