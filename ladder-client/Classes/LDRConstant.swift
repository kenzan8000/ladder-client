/// MARK: - User Defaults

struct LDRUserDefaults {
    static let uuid                             = "LDRUserDefaults.uuid"
    static let username                         = "LDRUserDefaults.username"
    static let password                         = "LDRUserDefaults.password"
    static let ldrUrlString                     = "LDRUserDefaults.ldrUrlString"
    static let apiKey                           = "LDRUserDefaults.apiKey"
}


/// MARK: - NotificationCenter

struct LDRNotificationCenter {
    //static let = Notification.Name("LDRNotificationCenter.")
}


/// MARK: - Error
enum LDRError: Error {
    // core data
    case deleteModelsFailed
    // internet connection
    case notReachable
    // login
    case invalidUsername
    case invalidPassword
    case invalidLdrUrl
    case invalidAuthenticityToken
    // api
    case invalidApiKey
}


/// MARK: - LDR
struct LDR {
    static let login =                      "/login"
    static let session =                    "/session"
    struct api {
        static let subs =                   "/api/subs"
        static let unread =                 "/api/unread"
        static let touch_all =              "/api/touch_all"
        struct pin {
            static let add =                "/api/pin/add"
            static let remove =             "/api/pin/remove"
        }
    }
}


/// MARK: - function

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
    return classString.substring(from: range!.upperBound)
}

/**
 * return ldr url
 *
 * @param path path String
 * @param params url parameters Hash
 * @return URL?
 */
func LDRUrl(path: String, params: Dictionary<String, String> = [:]) -> URL? {
    let ldrUrlString = UserDefaults.standard.string(forKey: LDRUserDefaults.ldrUrlString)
    if ldrUrlString == nil { return nil }
    var url = URL(string: "https://" + ldrUrlString! + "\(path)")
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
