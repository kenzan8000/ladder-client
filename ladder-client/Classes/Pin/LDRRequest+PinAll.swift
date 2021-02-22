import Combine
import HTMLReader

// MARK: - LDRRequest + PinAll
extension LDRRequest where Response == LDRPinAllResponses {
  // MARK: static api
  
  /// Request retrieving all pins
  /// - Returns:
  static func pinAll() -> Self {
    let url = URL(ldrPath: LDR.Api.pinAll)
    let body = ["ApiKey": LDRRequestHelper.getApiKey() ?? ""].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: LDRRequestHelper.createCookieHttpHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRPinAllResponses
typealias LDRPinAllResponses = [LDRPinAllResponse]

// MARK: - LDRPinAllResponse
struct LDRPinAllResponse: Decodable {
  // MARK: prooperty
  let createdOn: Int
  let link: String
  let title: String
}
