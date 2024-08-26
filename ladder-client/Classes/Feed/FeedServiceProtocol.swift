import Combine
import Foundation

// MARK: - FeedServiceProtocol

protocol FeedServiceProtocol: RootServiceProtocol {
    /// Load feedss
    func loadFeeds() async
    
    /// Mark feed as seen
    /// - Parameter feedId: target feed to be marked as seen
    func markFeedAsSeen(feedId: Int)

    /// Cancel all the request
    func cancel()
}
