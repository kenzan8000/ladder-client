import Combine
import Foundation

final class FeedStorage: FeedStorageProtocol {
    // MARK: - Private properties
    
    @Published private var articleFeeds: [ArticleFeed] = []
    
    // MARK: - Public methods
    
    @MainActor
    func set(feeds: [Feed]) {
        articleFeeds = feeds.map { (feed: Feed) in ArticleFeed(feed: feed, articles: []) }
    }
    
    @MainActor
    func set(articleList: ArticleList) {
        guard let index = articleFeeds.firstIndex(where: { (articleFeed: ArticleFeed) in articleFeed.feedId == articleList.feedId }) else {
            return
        }
        articleFeeds[index] = articleFeeds[index].duplicate(articles: articleList.articles)
    }
    
    func getArticleFeeds() -> AnyPublisher<[ArticleFeed], Never> {
        $articleFeeds.eraseToAnyPublisher()
    }
}
