import Foundation

// MARK: - Article

/// Model representing an article in Fastladder RSS feed.
struct Article: Codable, Equatable, Identifiable, Sendable {
    // MARK: - Private Enums
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case body = "body"
        case category = "category"
        case linkString = "link"
        case title = "title"
    }
    
    // MARK: - Private properties
    
    private let linkString: String
    
    // MARK: - Public properties

    let id: Int
    
    let body: String
    
    let category: String
    
    var link: URL? { URL(string: linkString) }

    let title: String
}
