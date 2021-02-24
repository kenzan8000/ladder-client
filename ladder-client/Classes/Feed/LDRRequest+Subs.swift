import Combine
import KeychainAccess
import Foundation

// MARK: - LDRRequest + Subs
extension LDRRequest where Response == LDRSubsResponse {
  // MARK: static api
  
  /// Request retrieving all subsUnread
  /// - Returns:
  static func subs() -> Self {
    let url = URL(ldrPath: LDRApi.Api.subs)
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    urlComponents?.queryItems = [URLQueryItem(name: "unread", value: "1")]
    let body = [
      "ApiKey": Keychain(service: .ldrServiceName, accessGroup: .ldrSuiteName)[LDRKeychain.apiKey] ?? ""
    ].HTTPBodyValue()
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
struct LDRSubResponse: Decodable {
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
