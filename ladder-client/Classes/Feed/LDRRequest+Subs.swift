import Combine
import KeychainAccess
import Foundation

// MARK: - LDRRequest + Subs
extension LDRRequest where Response == LDRSubsResponse {
  // MARK: static api
  
  /// Request retrieving all subsUnread
  /// - Parameters:
  ///   - apiKey: apiKey string
  ///   - ldrUrlString: domain + url path (optional) that runs fastladder app   
  /// - Returns: LDRRequest
  static func subs(apiKey: String?, ldrUrlString: String?) -> Self {
    let url = URL(ldrUrlString: ldrUrlString, ldrPath: LDRApi.Api.subs)
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    urlComponents?.queryItems = [URLQueryItem(name: "unread", value: "1")]
    let body = ["ApiKey": apiKey ?? ""].HTTPBodyValue()
    return LDRRequest(
      url: urlComponents?.url ?? url,
      method: .post(body),
      headers: .defaultHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRSubsResponse
typealias LDRSubsResponse = [LDRSubResponse]

// MARK: - LDRSubResponse
struct LDRSubResponse: Codable {
  // MARK: prooperty
  let rate: Int
  let folder: String
  let title: String
  let subscribeId: Int
  let link: String
  let icon: String
  let unreadCount: Int
  let subscribersCount: Int
  let feedlink: String
}
