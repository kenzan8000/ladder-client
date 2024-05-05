import Foundation

// MARK: - SignInServiceProtocol

protocol SignInServiceProtocol {
    /// - Parameters:
    ///   - username: Fastladder username `String`
    ///   - password: Fastladder password `String`
    func signIn(username: String, password: String) async throws

    /// Cancel signing in
    func cancel()
}
