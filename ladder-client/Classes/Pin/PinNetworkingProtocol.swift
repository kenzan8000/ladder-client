import Foundation

// MARK: - PinNetworkingProtocol

protocol PinNetworkingProtocol {
    /// Retrieve all the pins the user has
    /// - Returns: Response from `POST /api/pin/all` edpoint
    func all() async throws -> (Data, URLResponse)

    /// Cancel all the requests
    func cancel()
}
