import Foundation

// MARK: - Feed

/// Model representing an RSS feed.
struct Feed: Codable, Equatable, Identifiable, Sendable {
    // MARK: - Private Enums
    
    private enum CodingKeys: String, CodingKey {
        case id = "subscribe_id"
        case folder = "folder"
        case numberOfUnreadArticles = "unread_count"
        case rating = "rate"
        case title = "title"
    }
    
    // MARK: - Public properties

    let id: Int
    
    /// name of the folder. Fastladder allows user to name folder name for the RSS feed
    let folder: String
    
    /// number of unread articles in the RSS feed
    let numberOfUnreadArticles: Int

    /// rating 0-5. Fastladder allows user to rate the RSS feed
    let rating: Int
    
    /// title of the RSS feed
    let title: String
}
