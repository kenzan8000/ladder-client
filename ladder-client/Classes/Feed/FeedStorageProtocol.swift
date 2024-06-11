import Combine
import Foundation

protocol FeedStorageProtocol {
    func set(feeds: [Feed])
    
    func get() -> AnyPublisher<[Feed], Never>
}
