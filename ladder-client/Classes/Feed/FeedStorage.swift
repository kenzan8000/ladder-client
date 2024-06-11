import Combine
import Foundation

final class FeedStorage: FeedStorageProtocol {
    // MARK: - Private properties
    
    @Published private var feeds: [Feed] = []
    
    // MARK: - Public methods
    
    @MainActor
    func set(feeds: [Feed]) {
        self.feeds = feeds
    }
    
    func get() -> AnyPublisher<[Feed], Never> {
        $feeds.eraseToAnyPublisher()
    }
}
