import Combine
import Foundation
@testable import ladder_client

// MARK: - FeedStorageMock

final class FeedStorageMock: FeedStorageProtocol {
    @Published var articleFeeds = [ArticleFeed]()

    func set(feeds: [Feed]) {
        articleFeeds = feeds.map { (feed: Feed) in ArticleFeed(feed: feed, articles: []) }
    }
    
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
