import Combine
import HTMLReader

// MARK: - LDRRequest + PinAdd
extension LDRRequest where Response == LDRPinAddResponse {
  // MARK: static api
  
  /// Request adding a link to read later list
  /// - Parameter link: link URL to add the list
  /// - Returns: LDRRequest
  static func pinAdd(link: URL) -> Self {
    let url = URL(ldrPath: LDR.Api.pinAdd)
    let body = ["ApiKey": LDRRequestHelper.getApiKey() ?? "", "link": link.absoluteString].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: LDRRequestHelper.createCookieHttpHeader(url: url, body: body)
    )
  }
}

struct LDRPinAddResponse: Decodable {
  // MARK: prooperty
  let ErrorCode: Int
  let isSuccess: Bool
}
