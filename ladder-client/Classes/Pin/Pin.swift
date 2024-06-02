import Foundation

// MARK: - Pin

/// Model representing an article to read later. The article pin is usually added from subscribing Fastladder RSS feeds.
struct Pin: Codable, Identifiable, Sendable {
    // MARK: - Private Enums
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_on"
        case link = "link"
        case title = "title"
    }
    
    // MARK: - Public properties

    var id: String { link.absoluteString }

    let createdAt: Date
    
    let link: URL
    
    let title: String
}
