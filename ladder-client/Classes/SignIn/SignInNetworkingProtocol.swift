import Foundation

// MARK: - SignInNetworkingProtocol

protocol SignInNetworkingProtocol {
    /// - Parameters:
    ///   - username: Fastladder username `String`
    ///   - password: Fastladder password `String`
    /// - Returns: Response from `GET /login` edpoint
    func signIn(username: String, password: String) async throws -> (Data, URLResponse)
    
    /// - Parameters:
    ///   - username: Fastladder username `String`
    ///   - password: Fastladder password `String`
    ///   - authenticityToken: Fastladder  authenticity token retrieved from `SignInNetworkingProtocol.signIn`'s response HTML
    /// - Returns: Response from `GET /session` edpoint
    func session(username: String, password: String, authenticityToken: String) async throws -> (Data, URLResponse)

    func cancel()
}
