import JavaScriptCore


// MARK: - LDRSettingLoginOperationQueue
class LDRSettingLoginOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let shared = LDRSettingLoginOperationQueue()


    /// MARK: - initialization

    override init() {
        super.init()

        self.maxConcurrentOperationCount = 1
    }


    /// MARK: - destruction

    deinit {
        self.cancelAllOperations()
    }


    /// MARK: - public api

    /**
     * start login
     * @param completionHandler (json: JSON?, error: Error?) -> Void
     **/
    func start(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // invalid username
        let username = UserDefaults.standard.string(forKey: LDRUserDefaults.username)
        if username == nil { completionHandler(nil, LDRError.invalidUsername); return }
        // invalid password
        let password = UserDefaults.standard.string(forKey: LDRUserDefaults.password)
        if password == nil { completionHandler(nil, LDRError.invalidPassword); return }
        // invalid url
        let url = LDRUrl(path: LDR.login, params: ["username": username!, "password": password!])
        if url == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }
        // delete cookies
        for cookieName in ["_fastladder_session"] { HTTPCookieStorage.shared.deleteCookie(name: cookieName, domain: url!.host!) }
        // stop all network connections
        LDRFeedOperationQueue.default().cancelAllOperations()
        LDRPinOperationQueue.default().cancelAllOperations()
        self.cancelAllOperations()

        // request
        let request = NSMutableURLRequest(url: url!)
        self.addOperation(LDROperation(
            request: request as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!); return }
                    if !(object is Data) { completionHandler(nil, LDRError.invalidAuthenticityToken); return }
                    if response != nil { HTTPCookieStorage.shared.addCookies(httpUrlResponse: response) }

                    // parse html
                    let document = HTMLDocument(data: object as! Data, contentTypeHeader: nil)
                    let form = document.firstNode(matchingSelector: "script")
                    for child in form!.children {
                        if !(child is HTMLNode) { continue }

                        // parse ApiKey
                        let jsText = (child as! HTMLNode).textContent
                        let jsContext = JSContext()!
                        jsContext.evaluateScript(jsText)
                        jsContext.evaluateScript("var getApiKey = function() { return ApiKey; };")
                        // save ApiKey
                        let apiKey = jsContext.evaluateScript("getApiKey();").toString()
                        UserDefaults.standard.setValue(apiKey, forKey: LDRUserDefaults.apiKey)
                        UserDefaults.standard.synchronize()
                        break
                    }
                    completionHandler(nil, nil)
                }
            }
        ))
    }

    /// MARK: - private api

}
