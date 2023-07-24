import Combine
import Foundation
import KeychainAccess

// MARK: - LDRRequest + PinRemove
extension LDRRequest where Response == LDRPinRemoveResponse {
    // MARK: static api
    
    /// Request adding a link to read later list
    /// - Parameters:
    ///     - apiKey: apiKey string
    ///     - ldrUrlString: domain + url path (optional) that runs fastladder app
    ///     - link: link URL to add the list
    ///     - cookie: cookie string
    /// - Returns: LDRRequest
    static func pinRemove(apiKey: String?, ldrUrlString: String?, link: URL, cookie: String?) -> Self {
        let url = URL(ldrUrlString: ldrUrlString, ldrPath: LDRApi.Api.pinRemove)
        let body = [
            "ApiKey": apiKey ?? "",
            "link": link.absoluteString
        ].HTTPBodyValue()
        return LDRRequest(
            url: url,
            method: .post(body),
            headers: .defaultHeader(url: url, body: body, cookie: cookie)
        )
    }
}

// MARK: - LDRPinRemoveResponse
struct LDRPinRemoveResponse: Codable {
    // CodingKey
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case errorCode = "ErrorCode"
    }
    // MARK: prooperty
    let errorCode: Int
    let isSuccess: Bool
}
