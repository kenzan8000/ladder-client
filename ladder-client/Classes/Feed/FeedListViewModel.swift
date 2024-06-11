import Combine
import Foundation

// MARK: - FeedListViewModel

@Observable
final class FeedListViewModel {
    // MARK: - Private properties
    
    private let service: any FeedServiceProtocol
    
    private let storage: any FeedStorageProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var articleLists: [ArticleList] = []

    // MARK: - Public properties
    
    private(set) var feeds: [ArticleFeed] = []
    
    // MARK: - Init
    
    init(
        service: any FeedServiceProtocol,
        storage: any FeedStorageProtocol
    ) {
        self.service = service
        self.storage = storage
        storage.getFeeds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (feeds: [Feed]) in
                self?.feeds = feeds.map { (feed: Feed) in ArticleFeed(feed: feed, articles: []) }
            }
            .store(in: &self.cancellables)
        storage.getArticleLists()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (articleLists: [ArticleList]) in
                guard let self else {
                    return
                }
                let newLists = articleLists.filter { (articleList: ArticleList) in
                    !(self.articleLists.contains(articleList))
                }
                for newList in newLists {
                    guard let index = self.feeds.firstIndex(where: { (feed: ArticleFeed) in feed.feedId == newList.feedId }) else {
                        continue
                    }
                    self.feeds[index] = self.feeds[index].duplicate(articles: newList.articles)
                }
                self.articleLists = articleLists
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
    
    @MainActor
    func getArticles(feedId: Int) -> [Article] {
        guard let articleList = articleLists.first(where: { $0.id == feedId }) else {
            return []
        }
        return articleList.articles
    }
}
