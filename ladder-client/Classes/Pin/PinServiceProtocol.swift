import Combine
import Foundation

// MARK: - PinServiceProtocol

protocol PinServiceProtocol: RootServiceProtocol {
    /// Wheteher is currently getting pins or not
    var isGettingPins: Bool { get }
    
    /// Publisher that indicates whether is currently signing in or not
    var isGettingPinsPublisher: AnyPublisher<Bool, Never> { get }
    
    /// - Returns: All the pins the user has
    func getPins() async throws -> [Pin]

    /// Cancel all the request
    func cancel()
}
