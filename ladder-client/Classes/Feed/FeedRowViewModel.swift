import Foundation

// MARK: - FeedRowViewModel

@Observable
final class FeedRowViewModel {
    // MARK: - Private properties
    
    private let feed: Feed
    
    // MARK: - Public properties
    
    var text: String { feed.title }
       
    // MARK: - Init
    
    init(feed: Feed) {
        self.feed = feed
    }
}
