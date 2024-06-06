import Combine
import Foundation

// MARK: - RootServiceProtocol

protocol RootServiceProtocol {
    /// Wheteher is currently loading or not
    var isLoading: Bool { get }
    
    /// Publisher that indicates whether is currently loading or not
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
}
