// MARK: - LDRSettingLoginOperationQueue
class LDRSettingLoginOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let shared = LDRSettingLoginOperationQueue()
    var username: String?
    var password: String?
    var loginUrl: URL?


    /// MARK: - initialization

    override init() {
        super.init()

        LDRSettingLoginOperationQueue.default().maxConcurrentOperationCount = 1
    }


    /// MARK: - destruction

    deinit {
        LDRSettingLoginOperationQueue.default().cancelAllOperations()
    }


    /// MARK: - public api

    /**
     * start login
     * @param completionHandler (json: JSON?, error: Error?) -> Void
     **/
    func start(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // invalid username
        self.username = UserDefaults.standard.string(forKey: LDRUserDefaults.username)
        if self.username == nil {
            completionHandler(nil, LDRError.invalidUsername)
            return
        }
        // invalid password
        self.password = UserDefaults.standard.string(forKey: LDRUserDefaults.password)
        if self.password == nil {
            completionHandler(nil, LDRError.invalidPassword)
            return
        }
        // invalid url
        self.loginUrl = LDRUrl(path: LDR.API.login)
        if self.loginUrl == nil {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // stop all network connections
        LDRFeedOperationQueue.default().cancelAllOperations()
        LDRPinOperationQueue.default().cancelAllOperations()
        LDRSettingLoginOperationQueue.default().cancelAllOperations()

//        // delete cookies
//        let cookieNames = ["member_sid", ".LRC", ".LH", ".LL", "reader_sid"]
//        for cookieName in cookieNames {
//            HTTPCookieStorage.shared.deleteCookie(name: cookieName, domain: domain!)
//        }

        self.requestLogin(completionHandler: completionHandler)
    }


    func requestLogin(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        let loginRequest = NSMutableURLRequest(url: self.loginUrl!)
        self.addOperation(LDROperation(
            request: loginRequest as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!); return }
                    if !(object is Data) { completionHandler(nil, LDRError.htmlParseFailed); return }

                    let document = HTMLDocument(data: object as! Data, contentTypeHeader: nil)
                    let form = document.firstNode(matchingSelector: "form")
                    if form == nil { completionHandler(nil, LDRError.htmlParseFailed); return }
                    for child in form!.children {
                        if !(child is HTMLElement) { continue }
                        if (child as! HTMLElement).attributes["name"] != "authenticity_token" { continue }
                        LDRLOG((child as! HTMLElement).attributes["value"])

                    }
                }
            }
        ))
    }

}
