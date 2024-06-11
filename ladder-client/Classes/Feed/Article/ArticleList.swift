import Foundation

// MARK: - Article

/// Model representing list of articles in Fastladder RSS feed.
struct ArticleList: Codable, Equatable, Identifiable, Sendable {
    // MARK: - Private Enums
    
    private enum CodingKeys: String, CodingKey {
        case articles = "items"
        case feedId = "subscribe_id"
    }
    
    // MARK: - Public properties

    var id: Int { feedId }
    
    let articles: [Article]
    
    let feedId: Int
}
