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
  static func touchAll(subscribeId: Int) -> Self {
    let url = URL(ldrPath: LDRApi.Api.touchAll)
    let body = [
      "ApiKey": Keychain.ldr[LDRKeychain.apiKey] ?? "",
      "subscribe_id": "\(subscribeId)"
    ].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: .defaultHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRTouchAllResponse
struct LDRTouchAllResponse: Codable {
  // CodingKey
  enum CodingKeys: String, CodingKey {
    case isSuccess
    case errorCode = "ErrorCode"
  }
  // MARK: prooperty
  let errorCode: Int
  let isSuccess: Bool
}
