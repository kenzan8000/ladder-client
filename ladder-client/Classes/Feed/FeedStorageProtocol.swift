import Combine
import Foundation

protocol FeedStorageProtocol {
    func set(feeds: [Feed])
    
    func set(articleLists: [ArticleList])
    
    func add(articleList: ArticleList)
    
    func getFeeds() -> AnyPublisher<[Feed], Never>
    
    func getArticleLists() -> AnyPublisher<[ArticleList], Never>
}
