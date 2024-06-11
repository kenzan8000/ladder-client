import Combine
import Foundation
@testable import ladder_client

// MARK: - FeedStorageMock

final class FeedStorageMock: FeedStorageProtocol {
    @Published var feeds = [Feed]()
    
    @Published var articleLists = [ArticleList]()

    func set(feeds: [Feed]) {
        self.feeds = feeds
    }
    
    func set(articleLists: [ArticleList]) {
        self.articleLists = articleLists
    }
    
    func add(articleList: ArticleList) {
        self.articleLists.append(articleList)
    }
    
    func getFeeds() -> AnyPublisher<[Feed], Never> {
        $feeds.eraseToAnyPublisher()
    }
    
    func getArticleLists() -> AnyPublisher<[ArticleList], Never> {
        $articleLists.eraseToAnyPublisher()
    }
}
