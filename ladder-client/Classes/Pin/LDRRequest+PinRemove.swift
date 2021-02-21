import Combine
import HTMLReader

// MARK: - LDRRequest + PinRemove
extension LDRRequest where Response == LDRPinRemoveResponse {
  // MARK: static api
  
  /// Request adding a link to read later list
  /// - Parameter link: link URL to add the list  /// 
  /// - Returns: LDRRequest
  static func pinRemove(link: URL) -> Self {
    LDRRequest(
      url: URL(ldrPath: LDR.Api.pinRemove),
      method: .post(
        [
          "ApiKey": LDRRequestHelper.getApiKey() ?? "",
          "link": link.absoluteString
        ].HTTPBodyValue()
      )
    )
  }
}

struct LDRPinRemoveResponse: Decodable {
  // MARK: prooperty
  let ErrorCode: Int
  let isSuccess: Bool
}
