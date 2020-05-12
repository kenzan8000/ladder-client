import KeychainAccess
import NotificationCenter

// MARK: - User Defaults

enum LDRKeychain {
    static let serviceName = "org.kenzan8000.ladder-client"
    static let suiteName = "group.ladder-pin"
    static let uuid = "LDRKeychain.uuid"
    static let username = "LDRKeychain.username"
    static let password = "LDRKeychain.password"
    static let ldrUrlString = "LDRKeychain.ldrUrlString"
    static let apiKey = "LDRKeychain.apiKey"
    static let session = "LDRKeychain.session"
    static let darkMode = "LDRKeychain.darkMode"
}


// MARK: - NotificationCenter

enum LDRNotificationCenter {
    static let didLogin = Notification.Name("LDRNotificationCenter.didLogin")
    static let didGetUnread = Notification.Name("LDRNotificationCenter.didGetUnread")
    static let didGetInvalidUrlOrUsernameOrPasswordError = Notification.Name("LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError")
}


// MARK: - Error
enum LDRError: Error {
    // core data
    case deleteModelsFailed
    case saveModelsFailed
    // internet connection
    case notReachable
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


// MARK: - LDR
enum LDR {
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


// MARK: - function

/**
 * display log
 *
 * @param body log
 */
func LDRLOG(_ body: Any) {
#if DEBUG
    print(body)
#endif
}

/**
 * return class name
 *
 * @param classType classType
 * @return class name
 */
func LDRNSStringFromClass(_ classType: AnyClass) -> String {
    let classString = NSStringFromClass(classType)
    let range = classString.range(of: ".")
    //return classString.substring(from: range!.upperBound)
    return String(classString[range!.upperBound...])
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
        service: LDRKeychain.serviceName,
        accessGroup: LDRKeychain.suiteName
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

/**
 * return error message
 *
 * @param error Error?
 * @return error message string
 */
func LDRErrorMessage(error: Error?) -> String {
    if error == nil { return "Unknown Error" }
    if !(error is LDRError) { return "\(error!.localizedDescription)" }
    return "\(String(describing: error!))"
}
