import Foundation

// MARK: - FeedNetworkingProtocol

protocol FeedNetworkingProtocol {
    /// Retrieve all the feeds the user subscribes to
    /// - Returns: Response from `POST /api/subs` edpoint
    func feeds() async throws -> (Data, URLResponse)
    
    /// Retrieve all the unread articles from a feed
    /// - Parameters:
    ///   - feedId: feed's id
    /// - Returns: Response from `POST /api/unread` edpoint
    func unreadArticles(feedId: Int) async throws -> (Data, URLResponse)
    
     /// Remove all the unread articles from a feed
    /// - Parameters:
    ///   - feedId: feed's id
    /// - Returns: Response from `POST /api/touch_all` edpoint
    func removeUnreadArticles(feedId: Int) async throws -> (Data, URLResponse)
    
    /// Cancel all the requests
    func cancel()
}
