import Combine
import KeychainAccess

// MARK: - LDRRequest + PinAdd
extension LDRRequest where Response == LDRPinAddResponse {
  // MARK: static api
  
  /// Request adding a link to read later list
  /// - Parameters:
  ///   - link: pin url
  ///   - title: pin title
  /// - Returns: LDRRequest
  static func pinAdd(link: URL, title: String) -> Self {
    let url = URL(ldrPath: LDRApi.Api.pinAdd)
    let body = [
      "ApiKey": Keychain(service: .ldrServiceName, accessGroup: .ldrSuiteName)[LDRKeychain.apiKey] ?? "",
      "title": title,
      "link": link.absoluteString
    ].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: .defaultHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRPinAddResponse
struct LDRPinAddResponse: Decodable {
  // MARK: prooperty
  let ErrorCode: Int
  let isSuccess: Bool
}
