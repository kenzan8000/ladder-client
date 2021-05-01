import Combine
import Foundation
import KeychainAccess

// MARK: - LDRRequest + PinAdd
extension LDRRequest where Response == LDRPinAddResponse {
  // MARK: static api
  
  /// Request adding a link to read later list
  /// - Parameters:
  ///   - apiKey: apiKey string
  ///   - ldrUrlString: domain + url path (optional) that runs fastladder app
  ///   - title: pin title
  ///   - link: pin url
  /// - Returns: LDRRequest
  static func pinAdd(apiKey: String?, ldrUrlString: String?, title: String, link: URL) -> Self {
    let url = URL(ldrUrlString: ldrUrlString, ldrPath: LDRApi.Api.pinAdd)
    let body = [
      "ApiKey": apiKey ?? "",
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
struct LDRPinAddResponse: Codable {
  // CodingKey
  enum CodingKeys: String, CodingKey {
    case isSuccess
    case errorCode = "ErrorCode"
  }
  // MARK: prooperty
  let errorCode: Int
  let isSuccess: Bool
}
