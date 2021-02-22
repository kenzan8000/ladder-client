import Combine
import HTMLReader

// MARK: - LDRRequest + PinAdd
extension LDRRequest where Response == LDRPinAddResponse {
  // MARK: static api
  
  /// Request adding a link to read later list
  /// - Parameters:
  ///   - link: pin url
  ///   - title: pin title
  /// - Returns: LDRRequest
  static func pinAdd(link: URL, title: String) -> Self {
    let url = URL(ldrPath: LDR.Api.pinAdd)
    let body = ["ApiKey": LDRRequestHelper.getApiKey() ?? "", "title": title, "link": link.absoluteString].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: LDRRequestHelper.createCookieHttpHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRPinAddResponse
struct LDRPinAddResponse: Decodable {
  // MARK: prooperty
  let ErrorCode: Int
  let isSuccess: Bool
}
