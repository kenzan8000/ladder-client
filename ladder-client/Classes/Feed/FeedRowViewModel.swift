import Foundation

// MARK: - FeedRowViewModel

@Observable
final class FeedRowViewModel {
    // MARK: - Private properties
    
    private let feed: ArticleFeed
    
    // MARK: - Public properties
    
    var title: String { feed.title }
    
    var numberOfUnreadArticles: String { "\(feed.numberOfUnreadArticles)" }
    
    var hasArticles: Bool { !feed.articles.isEmpty }
       
    // MARK: - Init
    
    init(feed: ArticleFeed) {
        self.feed = feed
    }
}
