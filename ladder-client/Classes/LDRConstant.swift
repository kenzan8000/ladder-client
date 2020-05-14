import KeychainAccess

// MARK: - Keychain

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
    static let willResignActive = Notification.Name("LDRNotificationCenter.willResignActive")
    static let didBecomeActive = Notification.Name("LDRNotificationCenter.didBecomeActive")
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
}

// MARK: - LDR
enum LDR {
    static let login = "/login"
    static let session = "/session"
    enum Api {
        static let subs = "/api/subs"
        static let unread = "/api/unread"
        static let touchAll = "/api/touch_all"
        static let pinAdd = "/api/pin/add"
        static let pinRemove = "/api/pin/remove"
        static let pinAll = "/api/pin/all"
    }
    static let cookieName = "_fastladder_session"
}

// MARK: - function

/// display log
///
/// - Parameter body: body of log
func LDRLOG(_ body: Any) {
#if DEBUG
    print(body)
#endif
}

/// returns class name
///
/// - Parameter classType: type of class
/// - Returns: name of class
func LDRNSStringFromClass(_ classType: AnyClass) -> String {
    let classString = NSStringFromClass(classType)
    if let range = classString.range(of: ".") {
        return String(classString[range.upperBound...])
    }
    return ""
}

/// returns built ldr url
///
/// - Parameters:
///   - path: path of url
///   - params: quries of url
/// - Returns: built ldr url
func LDRUrl(path: String, params: [String: String] = [:]) -> URL? {
    // if params.count == 0 { return nil }
    
    guard let ldrUrlString = Keychain(
        service: LDRKeychain.serviceName,
        accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.ldrUrlString] else {
        return nil
    }

    guard let url = URL(string: "https://" + ldrUrlString + "\(path)") else {
        return nil
    }
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    let queryItems = params.map {
        URLQueryItem(name: "\($0)", value: "\($1)")
    }
    urlComponents?.queryItems = queryItems
    return urlComponents?.url
}

/// returns error message
///
/// - Parameter error: error
/// - Returns: error message
func LDRErrorMessage(error: Error?) -> String {
    guard let e = error else {
        return "Unknown Error"
    }
    if !(e is LDRError) {
        return "\(e.localizedDescription)"
    }
    return "\(String(describing: e))"
}
