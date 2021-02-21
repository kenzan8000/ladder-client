import Combine
import HTMLReader

// MARK: - LDRRequest + PinAll
extension LDRRequest where Response == LDRPinAllResponses {
  // MARK: static api
  
  /// Request retrieving all pins
  /// - Returns:
  static func pinAll() -> Self {
    LDRRequest(
      url: URL(ldrPath: LDR.Api.pinAll),
      method: .post(["ApiKey": LDRRequestHelper.getApiKey() ?? ""].HTTPBodyValue())
    )
  }
}

typealias LDRPinAllResponses = [LDRPinAllResponse]

struct LDRPinAllResponse: Decodable {
  // MARK: prooperty
  let createdOn: Int
  let link: String
  let title: String
}
