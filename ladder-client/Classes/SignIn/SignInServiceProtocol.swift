import Combine
import Foundation

// MARK: - SignInServiceProtocol

protocol SignInServiceProtocol {
    /// Wheteher is currently signing in or not
    var isSigningIn: Bool { get }
    
    /// Publisher that indicates whether is currently signing in or not
    var isSigningInPublisher: AnyPublisher<Bool, Never> { get }

    /// Whether is signed in or not
    var isSignedIn: Bool { get }
    
    /// Publisher that indicates whether is signed in or not
    var isSignedInPublisher: AnyPublisher<Bool, Never> { get }
    
    /// - Parameters:
    ///   - username: Fastladder username `String`
    ///   - password: Fastladder password `String`
    func signIn(username: String, password: String) async throws
    
    /// Sign out
    func signOut()

    /// Cancel signing in
    func cancel()
}
