import Foundation

// MARK: - FeedRowViewModel

@Observable
final class FeedRowViewModel {
    // MARK: - Private properties
    
    private let articleFeed: ArticleFeed
    
    // MARK: - Public properties
    
    var title: String { articleFeed.title }
    
    var numberOfArticles: String { "\(articleFeed.numberOfArticles)" }
    
    var hasArticles: Bool { !articleFeed.articles.isEmpty }
       
    // MARK: - Init
    
    init(articleFeed: ArticleFeed) {
        self.articleFeed = articleFeed
    }
}
