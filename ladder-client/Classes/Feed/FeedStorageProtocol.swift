import Combine
import Foundation

protocol FeedStorageProtocol {
    func set(feeds: [Feed])
    
    func set(articleList: ArticleList)
    
    func getArticleFeeds() -> AnyPublisher<[ArticleFeed], Never>
}
