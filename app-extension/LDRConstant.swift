import KeychainAccess
import NotificationCenter

// MARK: - User Defaults

enum LDRKeychain {
    static let uuid = "LDRKeychain.uuid"
    static let username = "LDRKeychain.username"
    static let password = "LDRKeychain.password"
    static let ldrUrlString = "LDRKeychain.ldrUrlString"
    static let apiKey = "LDRKeychain.apiKey"
    static let session = "LDRKeychain.session"
    static let darkMode = "LDRKeychain.darkMode"
}
// MARK: - String + LDRKeychain
extension String {
  static let ldrServiceName = "org.kenzan8000.ladder-client"
  static let ldrSuiteName = "group.ladder-pin"
}


// MARK: - NotificationCenter

enum LDRNotificationCenter {
    static let didLogin = Notification.Name("LDRNotificationCenter.didLogin")
    static let didGetInvalidUrlOrUsernameOrPasswordError = Notification.Name("LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError")
}


// MARK: - Error
enum LDRError: Error {
    // core data
    case deleteModelsFailed
    case saveModelsFailed
    // internet connection
    case notReachable
    // failed
    case failed(String)
    // login
    case invalidUsername
    case invalidPassword
    case invalidLdrUrl
    case invalidUsernameOrPassword
    case invalidUrlOrUsernameOrPassword
    case invalidAuthenticityToken
    // api
    case invalidApiKey
    // app extension
    case invalidPinUrl
}


// MARK: - LDRApi
enum LDRApi {
    static let login =                      "/login"
    static let session =                    "/session"
    enum api {
        static let subs =                   "/api/subs"
        static let unread =                 "/api/unread"
        static let touch_all =              "/api/touch_all"
        enum pin {
            static let add =                "/api/pin/add"
            static let remove =             "/api/pin/remove"
            static let all =                "/api/pin/all"
        }
    }

    static let cookieName = "_fastladder_session"
}

/**
 * return ldr url
 *
 * @param path path String
 * @param params url parameters Hash
 * @return URL?
 */
func LDRUrl(path: String, params: Dictionary<String, String> = [:]) -> URL? {
    guard let ldrUrlString = Keychain(
        service: .ldrServiceName,
        accessGroup: .ldrSuiteName
        )[LDRKeychain.ldrUrlString] else {
        return nil
    }
    
    var url = URL(string: "https://" + ldrUrlString + "\(path)")
    if url != nil && params.count > 0 {
        var urlComponents = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        let queryItems = params.map { return URLQueryItem(name: "\($0)", value: "\($1)") }
        urlComponents?.queryItems = queryItems
        url = urlComponents?.url
    }
    return url
}
