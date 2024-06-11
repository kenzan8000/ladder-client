import Combine
import Foundation

// MARK: - PinServiceProtocol

protocol PinServiceProtocol: RootServiceProtocol {
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
