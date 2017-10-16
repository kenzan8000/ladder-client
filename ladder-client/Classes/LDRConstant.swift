/// MARK: - User Defaults

struct LDRUserDefaults {
    static let uuid                             = "LDRUserDefaults.uuid"
    static let username                         = "LDRUserDefaults.username"
    static let password                         = "LDRUserDefaults.password"
    static let ldrUrlString                     = "LDRUserDefaults.ldrUrlString"
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
}


/// MARK: - LDR
struct LDR {
    struct API {
        static let index =                  "/"
        static let login =                  "/login"
        static let loginIndex =             "/login/index"
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
 * @param path path string
 * @return URL?
 */
func LDRUrl(path: String) -> URL? {
    let ldrUrlString = UserDefaults.standard.string(forKey: LDRUserDefaults.ldrUrlString)
    if ldrUrlString == nil { return nil }
    return URL(string: ldrUrlString! + "/path")
}
