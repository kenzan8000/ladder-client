import Combine
import Foundation

// MARK: - FeedService

final class FeedService: FeedServiceProtocol {
    // MARK: - Public properties
    
    @Published private(set) var isLoading = false
    
    lazy var isLoadingPublisher: AnyPublisher<Bool, Never> = $isLoading.eraseToAnyPublisher()
}
