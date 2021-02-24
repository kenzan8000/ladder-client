import Combine
import KeychainAccess
import Foundation

// MARK: - LDRRequest + TouchAll
extension LDRRequest where Response == LDRTouchAllResponse {
  // MARK: static api
  
  /// Request making the subsucription feed's all articles read
  /// - Parameters:
  ///   - subscribeId: subscribe id
  /// - Returns:
  static func touchAll(subscribeId: String) -> Self {
    let url = URL(ldrPath: LDRApi.Api.touchAll)
    let body = [
      "ApiKey": Keychain(service: .ldrServiceName, accessGroup: .ldrSuiteName)[LDRKeychain.apiKey] ?? "",
      "subscribe_id": subscribeId
    ].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: .defaultHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRTouchAllResponse
struct LDRTouchAllResponse: Decodable {
  // MARK: prooperty
  let ErrorCode: Int
  let isSuccess: Bool
}
