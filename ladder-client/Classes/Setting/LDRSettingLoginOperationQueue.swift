// MARK: - LDRSettingLoginOperationQueue
class LDRSettingLoginOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let shared = LDRSettingLoginOperationQueue()
    var username: String?
    var password: String?
    var memberSidUrl: URL?
    var sessionUrl: URL?
    var readerSidUrl: URL?


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
        self.memberSidUrl = LDRUrl(path: LDR.API.index)
        self.sessionUrl = LDRUrl(path: LDR.API.login)
        self.readerSidUrl = LDRUrl(path: LDR.API.loginIndex)
        let domain = LDRDomain()
        if self.memberSidUrl == nil || self.sessionUrl == nil || self.readerSidUrl == nil || domain == nil {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // stop all network connections
        LDRFeedOperationQueue.default().cancelAllOperations()
        LDRPinOperationQueue.default().cancelAllOperations()
        LDRSettingLoginOperationQueue.default().cancelAllOperations()
        // delete cookies
        let cookieNames = ["member_sid", ".LRC", ".LH", ".LL", "reader_sid"]
        for cookieName in cookieNames {
            HTTPCookieStorage.shared.deleteCookie(name: cookieName, domain: domain!)
        }

        self.requestMemberSid(completionHandler: completionHandler)

    }


    func requestMemberSid(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // get member_sid
        let memberSidRequest = NSMutableURLRequest(url: memberSidUrl!)
        self.addOperation(LDROperation(
            request: memberSidRequest as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!) }
                    HTTPCookieStorage.shared.addCookies(httpUrlResponse: response)
                    self.requestSession(completionHandler: completionHandler)
                }
            }
        ))
    }

    func requestSession(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // get cookies .LRC, .LH, .LL
        let sessionRequest = NSMutableURLRequest(url: URL(url: sessionUrl!, parameters: ["livedoor_id": self.username!, "password": self.password!])!)
        self.addOperation(LDROperation(
            request: sessionRequest as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!) }
                    HTTPCookieStorage.shared.addCookies(httpUrlResponse: response)
                    self.requestReaderSid(completionHandler: completionHandler)
                }
            }
        ))
    }

    func requestReaderSid(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // get reader_sid
        let readerSidRequest = NSMutableURLRequest(url: readerSidUrl!)
        self.addOperation(LDROperation(
            request: readerSidRequest as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!) }
                    HTTPCookieStorage.shared.addCookies(httpUrlResponse: response)
                    completionHandler(nil, nil)
                }
            }
        ))
    }

}
