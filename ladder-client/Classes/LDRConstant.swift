/// MARK: - User Defaults

enum LDRUserDefaults {
    static let suiteName = "group.ladder-pin"
    static let uuid = "LDRUserDefaults.uuid"
    static let username = "LDRUserDefaults.username"
    static let password = "LDRUserDefaults.password"
    static let ldrUrlString = "LDRUserDefaults.ldrUrlString"
    static let apiKey = "LDRUserDefaults.apiKey"
    static let session = "LDRUserDefaults.session"
    static let darkMode = "LDRUserDefaults.darkMode"
}


/// MARK: - NotificationCenter

enum LDRNotificationCenter {
    static let didLogin = Notification.Name("LDRNotificationCenter.didLogin")
    static let didGetUnread = Notification.Name("LDRNotificationCenter.didGetUnread")
    static let didGetInvalidUrlOrUsernameOrPasswordError = Notification.Name("LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError")
}


/// MARK: - Error
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


/// MARK: - LDR
enum LDR {
    static let login = "/login"
    static let session = "/session"
    enum api {
        static let subs = "/api/subs"
        static let unread = "/api/unread"
        static let touch_all = "/api/touch_all"
        enum pin {
            static let add = "/api/pin/add"
            static let remove = "/api/pin/remove"
            static let all = "/api/pin/all"
        }
    }
    static let cookieName = "_fastladder_session"
}


/// MARK: - function

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
    let range = classString.range(of: ".")
    return String(classString[range!.upperBound...])
}

/// returns built ldr url
///
/// - Parameters:
///   - path: path of url
///   - params: quries of url
/// - Returns: built ldr url
func LDRUrl(path: String, params: Dictionary<String, String> = [:]) -> URL? {
    //if params.count == 0 { return nil }
    let ldrUrlString = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.ldrUrlString)
    if ldrUrlString == nil { return nil }
    guard let url = URL(string: "https://" + ldrUrlString! + "\(path)") else { return nil }
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    let queryItems = params.map { return URLQueryItem(name: "\($0)", value: "\($1)") }
    urlComponents?.queryItems = queryItems
    return urlComponents?.url
}

/// returns error message
///
/// - Parameter error: error
/// - Returns: error message
func LDRErrorMessage(error: Error?) -> String {
    if error == nil { return "Unknown Error" }
    if !(error is LDRError) { return "\(error!.localizedDescription)" }
    return "\(String(describing: error!))"
}
