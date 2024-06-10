import Combine
import Foundation

// MARK: - PinServiceProtocol

protocol PinServiceProtocol: RootServiceProtocol {
    /// Wheteher is currently getting pins or not
    var isGettingPins: Bool { get }
    
    /// Publisher that indicates whether is currently signing in or not
    var isGettingPinsPublisher: AnyPublisher<Bool, Never> { get }
    
    /// Load pins
    func loadPins() async

    /// Cancel all the request
    func cancel()
}
