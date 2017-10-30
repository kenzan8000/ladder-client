import JavaScriptCore


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
        if self.username == nil { completionHandler(nil, LDRError.invalidUsername); return }
        // invalid password
        self.password = UserDefaults.standard.string(forKey: LDRUserDefaults.password)
        if self.password == nil { completionHandler(nil, LDRError.invalidPassword); return }
        // invalid url
        self.loginUrl = LDRUrl(path: LDR.API.login, params: ["username": self.username!, "password": self.password!])
        if self.loginUrl == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }

        // delete cookies
        for cookieName in ["_fastladder_session"] {
            HTTPCookieStorage.shared.deleteCookie(name: cookieName, domain: self.loginUrl!.host!)
        }

        // stop all network connections
        LDRFeedOperationQueue.default().cancelAllOperations()
        LDRPinOperationQueue.default().cancelAllOperations()
        LDRSettingLoginOperationQueue.default().cancelAllOperations()

        self.requestLogin(completionHandler: completionHandler)
    }


    func requestLogin(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        if self.loginUrl == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }

        let request = NSMutableURLRequest(url: self.loginUrl!)
        self.addOperation(LDROperation(
            request: request as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!); return }
                    if !(object is Data) { completionHandler(nil, LDRError.invalidAuthenticityToken); return }
                    if response != nil { HTTPCookieStorage.shared.addCookies(httpUrlResponse: response) }

                    let str = String(data: object as! Data, encoding: String.Encoding.utf8)
                    LDRLOG(str!)

                    // parse html
                    let document = HTMLDocument(data: object as! Data, contentTypeHeader: nil)
                    let form = document.firstNode(matchingSelector: "script")
                    for child in form!.children {
                        if !(child is HTMLNode) { continue }

                        let jsText = (child as! HTMLNode).textContent
                        let jsContext = JSContext()!
                        jsContext.evaluateScript(jsText)
                        jsContext.evaluateScript("var getApiKey = function() { return ApiKey; };")

                        let apiKey = jsContext.evaluateScript("getApiKey();").toString()
                        UserDefaults.standard.setValue(apiKey, forKey: LDRUserDefaults.apiKey)
                        UserDefaults.standard.synchronize()

                        //UserDefaults.standard.string(forKey: LDRUserDefaults.apiKey)
                    }
                }
            }
        ))
    }

}
