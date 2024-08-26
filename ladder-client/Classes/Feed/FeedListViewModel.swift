import Combine
import Foundation

// MARK: - FeedListViewModel

@Observable
final class FeedListViewModel {
    // MARK: - Private properties
    
    private let feedService: any FeedServiceProtocol
    
    private let feedStorage: any FeedStorageProtocol
    
    private let pinService: any PinServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public properties
    
    private(set) var articleFeeds: [ArticleFeed] = []
    
    var selectedArticleFeed: ArticleFeed?
    
    // MARK: - Init
    
    init(
        feedService: any FeedServiceProtocol,
        feedStorage: any FeedStorageProtocol,
        pinService: any PinServiceProtocol
    ) {
        self.feedService = feedService
        self.feedStorage = feedStorage
        self.pinService = pinService
        feedStorage.getArticleFeeds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (articleFeeds: [ArticleFeed]) in
                self?.articleFeeds = articleFeeds
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Public methods
    
    @MainActor
    func loadFeeds() async {
        guard !feedService.isLoading else {
            return
        }
        await feedService.loadFeeds()
    }
    
    func selectArticleFeedIfNeeded(_ articleFeed: ArticleFeed) {
        guard !articleFeed.articles.isEmpty else {
            return
        }
        selectedArticleFeed = articleFeed
        feedService.markFeedAsSeen(feedId: articleFeed.feedId)
    }
    
    func makeArticleListViewModel(articles: [Article]) -> ArticleListViewModel {
        ArticleListViewModel(pinService: pinService, articles: articles)
    }
}
