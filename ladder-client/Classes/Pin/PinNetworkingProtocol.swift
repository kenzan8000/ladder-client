import Foundation

// MARK: - PinNetworkingProtocol

protocol PinNetworkingProtocol {
    /// Retrieve all the pins the user has
    /// - Returns: Response from `POST /api/pin/all` edpoint
    func pins() async throws -> (Data, URLResponse)
    
    /// Add a pin to the list
    /// - Parameters:
    ///   - title: pin's title
    ///   - link: pin's link
    /// - Returns: Response from `POST /api/pin/add` edpoint
    func addPin(title: String, link: URL) async throws -> (Data, URLResponse)
    
     /// Remove a pin from the list
    /// - Parameters:
    ///   - link: pin's link
    /// - Returns: Response from `POST /api/pin/remove` edpoint
    func removePin(link: URL) async throws -> (Data, URLResponse)
    
    /// Cancel all the requests
    func cancel()
}
