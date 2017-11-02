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
        // stop all network connections
        LDRFeedOperationQueue.shared.cancelAllOperations()
        LDRPinOperationQueue.shared.cancelAllOperations()
        self.cancelAllOperations()

        // delete cookies
        //let url = LDRUrl(path: LDR.login)
        //if url == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }
        //for cookieName in ["_fastladder_session"] { HTTPCookieStorage.shared.deleteCookie(name: cookieName, domain: url!.host!) }

        // request login
        self.requestLogin(completionHandler: completionHandler)
    }

    /**
     * request login
     * @param completionHandler (json: JSON?, error: Error?) -> Void
     **/
    func requestLogin(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // invalid username
        let username = UserDefaults.standard.string(forKey: LDRUserDefaults.username)
        if username == nil || username!.characters.count < 3 { completionHandler(nil, LDRError.invalidUsername); return }
        // invalid password
        let password = UserDefaults.standard.string(forKey: LDRUserDefaults.password)
        if password == nil || password!.characters.count < 3 { completionHandler(nil, LDRError.invalidPassword); return }
        // invalid url
        let url = LDRUrl(path: LDR.login, params: ["username": username!, "password": password!])
        //let url = LDRUrl(path: LDR.login)
        if url == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }

        // request
        let request = NSMutableURLRequest(url: url!)
        self.addOperation(LDROperation(
            request: request as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!); return }
                    if !(object is Data) { completionHandler(nil, LDRError.invalidAuthenticityToken); return }
                    //if response != nil { HTTPCookieStorage.shared.addCookies(httpUrlResponse: response) }

                    // parse html
                    let authenticityToken = self.getAuthencityToken(htmlData: object as! Data)
                    //var authenticityToken: String? = nil
                    //let document = HTMLDocument(data: object as! Data, contentTypeHeader: nil)
                    //let form = document.firstNode(matchingSelector: "form")
                    //if form == nil { completionHandler(nil, LDRError.invalidAuthenticityToken); return }
                    //for child in form!.children {
                    //    if !(child is HTMLElement) { continue }
                    //    if (child as! HTMLElement)["name"] != "authenticity_token" { continue }
                    //    if !((child as! HTMLElement)["value"] is String) { continue }
                    //    authenticityToken = (child as! HTMLElement)["value"] as! String
                    //    break
                    //}
                    if authenticityToken == nil { completionHandler(nil, LDRError.invalidAuthenticityToken); return }

                    self.requestSession(authenticityToken: authenticityToken!, completionHandler: completionHandler)
                }
            }
        ))

    }

    /**
     * request session
     * @param authenticityToken String
     * @param completionHandler (json: JSON?, error: Error?) -> Void
     **/
    func requestSession(authenticityToken: String, completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // invalid username
        let username = UserDefaults.standard.string(forKey: LDRUserDefaults.username)
        if username == nil { completionHandler(nil, LDRError.invalidUsername); return }
        // invalid password
        let password = UserDefaults.standard.string(forKey: LDRUserDefaults.password)
        if password == nil { completionHandler(nil, LDRError.invalidPassword); return }

        // invalid url
        let url = LDRUrl(path: LDR.session)
        if url == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }

        // request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ["username": username!, "password": password!, "authenticity_token": authenticityToken].HTTPBodyValue()
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.addOperation(LDROperation(
            request: request as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!); return }
                    if !(object is Data) { completionHandler(nil, LDRError.invalidApiKey); return }
                    //if response != nil { HTTPCookieStorage.shared.addCookies(httpUrlResponse: response) }

                    let authenticityToken = self.getAuthencityToken(htmlData: object as! Data)
                    if authenticityToken != nil { completionHandler(nil, LDRError.invalidPassword); return }

                    var apiKey = "undefined"
                    let document = HTMLDocument(data: object as! Data, contentTypeHeader: nil)

                    LDRLOG(String(data: object as! Data, encoding: .utf8)!)

                    let scripts = document.nodes(matchingSelector: "script")
                    if scripts == nil { completionHandler(nil, LDRError.invalidApiKey); return }
                    for script in scripts {
                        for child in script.children {
                            if !(child is HTMLNode) { continue }

                            // parse ApiKey
                            let jsText = (child as! HTMLNode).textContent
                            let jsContext = JSContext()!
                            jsContext.evaluateScript(jsText)
                            jsContext.evaluateScript("var getApiKey = function() { return ApiKey; };")
                            // save ApiKey
                            apiKey = jsContext.evaluateScript("getApiKey();").toString()
                            if apiKey == "undefined" { continue }
                            break
                        }
                        if apiKey != "undefined" { break }
                    }
                    if apiKey == "undefined" { completionHandler(nil, LDRError.invalidApiKey); return }

                    UserDefaults.standard.setValue(apiKey, forKey: LDRUserDefaults.apiKey)
                    UserDefaults.standard.synchronize()
                    completionHandler(nil, nil)
                }
            }
        ))

    }


    /// MARK: - private api

    /**
     * get authenticity_token by html data
     * @param data Data
     * @return authenticity_token String?
     **/
    private func getAuthencityToken(htmlData: Data) -> String? {
        var authenticityToken: String? = nil
        let document = HTMLDocument(data: htmlData, contentTypeHeader: nil)
        let form = document.firstNode(matchingSelector: "form")
        if form == nil { return authenticityToken }
        for child in form!.children {
            if !(child is HTMLElement) { continue }
            if (child as! HTMLElement)["name"] != "authenticity_token" { continue }
            if !((child as! HTMLElement)["value"] is String) { continue }
            authenticityToken = (child as! HTMLElement)["value"] as! String
            break
        }
        return authenticityToken
    }

}
