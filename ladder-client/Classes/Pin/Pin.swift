import Foundation

// MARK: - Pin

/// Model representing an article to read later. The article model is called pin, and it's stored on Fastladder's DB.
struct Pin: Codable, Equatable, Identifiable, Sendable {
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Fastladder returns URL query with "&amp;" so replace them with "&"...
        let absoluteString = try container.decode(String.self, forKey: .link)
        guard let link = URL(string: absoluteString.replacingOccurrences(of: "&amp;", with: "&")) else {
            throw PinDecodeError.link(absoluteString: absoluteString)
        }
        self.link = link
        
        self.cratedAtInUnixTimestamp = try container.decode(TimeInterval.self, forKey: .cratedAtInUnixTimestamp)
        self.title = try container.decode(String.self, forKey: .title)
    }
}

// MARK: - PinDecodeError

enum PinDecodeError: Error {
    case link(absoluteString: String)
    
    var localizedDescription: String {
        switch self {
        case let .link(absoluteString):
            return "Failed to decode link \"\(absoluteString)\"."
        }
    }
}
