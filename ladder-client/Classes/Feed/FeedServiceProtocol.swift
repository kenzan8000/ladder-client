import Combine
import Foundation

// MARK: - FeedServiceProtocol

protocol FeedServiceProtocol: RootServiceProtocol {
    /// Load feedss
    func loadFeeds() async

    /// Cancel all the request
    func cancel()
}
