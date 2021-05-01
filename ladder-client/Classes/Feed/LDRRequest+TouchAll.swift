import Combine
import KeychainAccess
import Foundation

// MARK: - LDRRequest + TouchAll
extension LDRRequest where Response == LDRTouchAllResponse {
  // MARK: static api
  
  /// Request making the subsucription feed's all articles read
  /// - Parameters:
  ///   - apiKey: apiKey string
  ///   - ldrUrlString: domain + url path (optional) that runs fastladder app
  ///   - subscribeId: subscribe id
  /// - Returns:
  static func touchAll(apiKey: String?, ldrUrlString: String?, subscribeId: Int) -> Self {
    let url = URL(ldrUrlString: ldrUrlString, ldrPath: LDRApi.Api.touchAll)
    let body = [
      "ApiKey": apiKey ?? "",
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
