import Foundation

// MARK: - Feed

/// Model representing an RSS feed and the articles in the RSS feed.
struct ArticleFeed: Equatable, Hashable, Identifiable, Sendable {
    // MARK: - Private properties
    
    private let feed: Feed
    
    // MARK: - Public properties
    
    var id: String {
        "feed id: \(feed.id), number of articles: \(articles.count), marked as seen: \(isMarkedAsSeen)"
    }
    
    var feedId: Int { feed.id }
    
    let articles: [Article]

    /// name of the folder. Fastladder allows user to name folder that RSS feed belongs to
    var folder: String { feed.folder }
    
    /// number of unread articles in the RSS feed
    var numberOfArticles: Int { feed.numberOfUnreadArticles }
    
    /// rating 0-5. Fastladder allows user to rate the RSS feed
    var rating: Int { feed.rating }
    
    /// title of the RSS feed
    var title: String { feed.title }
    
    /// whether the feed is already marked as seen
    private(set) var isMarkedAsSeen = false
    
    // MARK: - Init
    
    init(feed: Feed, articles: [Article]) {
        self.feed = feed
        self.articles = articles
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Public methods
    
    func duplicate(articles: [Article]) -> Self {
        Self(feed: feed, articles: articles)
    }
    
    mutating func markAsSeen() {
        isMarkedAsSeen = true
    }
}
