import Combine
import Foundation
import KeychainAccess

// MARK: - LDRRequest + PinAll
extension LDRRequest where Response == LDRPinAllResponse {
  // MARK: static api
  
  /// Request retrieving all pins
  /// - Parameters:
  ///   - apiKey: apiKey string
  ///   - ldrUrlString: domain + url path (optional) that runs fastladder app
  /// - Returns: LDRRequest
  static func pinAll(apiKey: String?, ldrUrlString: String?) -> Self {
    let url = URL(ldrUrlString: ldrUrlString, ldrPath: LDRApi.Api.pinAll)
    let body = ["ApiKey": apiKey ?? ""].HTTPBodyValue()
    return LDRRequest(
      url: url,
      method: .post(body),
      headers: .defaultHeader(url: url, body: body)
    )
  }
}

// MARK: - LDRPinAllResponse
typealias LDRPinAllResponse = [LDRPinResponse]

// MARK: - LDRPinResponse
struct LDRPinResponse: Codable {
  // MARK: prooperty
  let createdOn: Int
  let link: String
  let title: String
}
