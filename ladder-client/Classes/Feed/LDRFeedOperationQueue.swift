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
        request.httpBody = ["ApiKey": apiKey!].HTTPBodyValue()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }

        self.addOperation(LDROperation(
            request: request as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                var json = JSON([])
                do {
                    if object != nil {
                        let jsonString = try String(data: object as! Data, encoding: .utf8)
                        json = try JSON(string: jsonString)
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
