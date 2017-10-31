// MARK: - LDRFeedOperationQueue
class LDRFeedOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let shared = LDRFeedOperationQueue()
    var subsUrl: URL?
    var unreadUrl: URL?
    var touchAllUrl: URL?


    /// MARK: - initialization

    override init() {
        super.init()
    }


    /// MARK: - destruction

    deinit {
        LDRFeedOperationQueue.default().cancelAllOperations()
    }


    /// MARK: - public api

    /**
     * start
     * @param completionHandler (json: JSON?, error: Error?) -> Void
     **/
    func start(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        self.requestSubs(completionHandler: completionHandler)
    }

    /**
     * request subs
     * @param completionHandler (json: JSON?, error: Error?) -> Void
     **/
    func requestSubs(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // stop all feed operations
        self.cancelAllOperations()
        self.maxConcurrentOperationCount = 1

        // invalid ApiKey
        let apiKey = UserDefaults.standard.string(forKey: LDRUserDefaults.apiKey)
        if apiKey == nil || apiKey == "" { completionHandler(nil, LDRError.invalidApiKey); return }
        // invalid url
        let url = LDRUrl(path: LDR.api.subs, params: ["unread": "1"])
        if url == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }

        // request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        //request.httpBody = ["ApiKey": apiKey!].HTTPBodyValue()
        request.httpBody = "{\"ApiKey\": \"\(apiKey!)\"}".data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }
        //request.setValue("*/*", forHTTPHeaderField: "Accept")
        //request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        //request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36", forHTTPHeaderField: "User-Agent")
        if HTTPCookieStorage.shared.hasCookie(name: "_fastladder_session", domain: url!.host!) {
            request.setValue("_fastladder_session="+HTTPCookieStorage.shared.value(name: "_fastladder_session", domain: url!.host!)!, forHTTPHeaderField: "Cookie")
        }

        self.addOperation(LDROperation(
            request: request as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                var json = JSON([:])
                do {
                    if object != nil {
                        LDRLOG(response!.allHeaderFields)
                        let jsonString = try String(data: object as! Data, encoding: .utf8)
                        LDRLOG(jsonString!)
                        json = try JSON(string: jsonString)
                        LDRLOG(json)
                        let json2 = try JSON(data: object as! Data)
                        LDRLOG(json2)
                    }
                }
                catch let e { completionHandler(nil, e); return }
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!); return }

                    completionHandler(json, nil)
                }
            }
        ))

    }

    /**
     * request unread
     **/
    func requestUnread() {
        self.maxConcurrentOperationCount = 5
    }

    /**
     * request touch_all
     **/
    func requestTouchAll() {
        self.maxConcurrentOperationCount = 5
    }

}
