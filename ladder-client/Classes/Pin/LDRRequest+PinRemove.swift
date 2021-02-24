import Combine
import HTMLReader

// MARK: - LDRRequest + PinRemove
extension LDRRequest where Response == LDRPinRemoveResponse {
  // MARK: static api
  
  /// Request adding a link to read later list
  /// - Parameter link: link URL to add the list  /// 
  /// - Returns: LDRRequest
  static func pinRemove(link: URL) -> Self {
    let url = URL(ldrPath: LDRApi.Api.pinRemove)
    let body = ["ApiKey": LDRRequestHelper.getApiKey() ?? "", "link": link.absoluteString].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: LDRRequestHelper.createCookieHttpHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRPinRemoveResponse
struct LDRPinRemoveResponse: Decodable {
  // MARK: prooperty
  let ErrorCode: Int
  let isSuccess: Bool
}
