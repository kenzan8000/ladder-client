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
    
    /// Add a pin to the list
    /// - Parameters:
    ///   - title: pin's title
    ///   - link: pin's link
    /// - Returns: Whether  the operation succeeded or not
    func addPin(title: String, link: URL) async -> Bool
    
    /// Remove a pin from the list
    /// - Parameters:
    ///   - link: pin's link
    /// - Returns: Whether  the operation succeeded or not
    func removePin(link: URL) async -> Bool

    /// Cancel all the request
    func cancel()
}
