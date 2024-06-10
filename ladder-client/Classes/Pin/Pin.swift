import Foundation

// MARK: - Pin

/// Model representing an article to read later. The article pin is usually added from subscribing Fastladder RSS feeds.
struct Pin: Codable, Identifiable, Sendable {
    // MARK: - Private Enums
    
    private enum CodingKeys: String, CodingKey {
        case cratedAtInUnixTimestamp = "created_on"
        case link = "link"
        case title = "title"
    }
    
    // MARK: - Private properties
    
    private let cratedAtInUnixTimestamp: TimeInterval
    
    // MARK: - Public properties

    var id: String { link.absoluteString }

    var createdAt: Date { Date(timeIntervalSince1970: cratedAtInUnixTimestamp) }
    
    let link: URL
    
    let title: String
    
    // MARK: - Init
    
    init(
        createdAt: Date,
        link: URL,
        title: String
    ) {
        self.cratedAtInUnixTimestamp = createdAt.timeIntervalSince1970
        self.link = link
        self.title = title
    }
}
