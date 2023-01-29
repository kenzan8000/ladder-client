import Foundation
import HTMLReader

// MARK: - LDRRSSFeedFinderViewModel
struct LDRRSSFeedFinderViewModel {
  // MARK: property
  let urlSession: URLSession
  
  func loadRSSFeeds(for request: LDRRequest<LDRRSSFeedResponse>) async throws -> (LDRRSSFeedResponse, URLResponse) {
    try await urlSession.data(for: request)
  }
}
