import Combine
import Foundation

protocol FeedStorageProtocol {
    func set(feeds: [Feed])
    
    func set(articleList: ArticleList)
    
    func markAsSeen(feedId: Int)
    
    func getArticleFeeds() -> AnyPublisher<[ArticleFeed], Never>
}
