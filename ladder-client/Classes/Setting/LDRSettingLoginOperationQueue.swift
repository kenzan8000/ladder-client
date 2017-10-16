// MARK: - LDRSettingLoginOperationQueue
class LDRSettingLoginOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let sharedInstance = LDRSettingLoginOperationQueue()


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
        let username = UserDefaults.standard.string(forKey: LDRUserDefaults.username)
        if username == nil {
            completionHandler(nil, LDRError.invalidUsername)
            return
        }
        // invalid password
        let password = UserDefaults.standard.string(forKey: LDRUserDefaults.password)
        if password == nil {
            completionHandler(nil, LDRError.invalidPassword)
            return
        }
        // invalid url
        let memberSidUrl = LDRUrl(path: LDR.API.index)
        let sessionUrl = LDRUrl(path: LDR.API.login)
        let readerSidUrl = LDRUrl(path: LDR.API.loginIndex)
        if memberSidUrl == nil || sessionUrl == nil || readerSidUrl == nil {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // get member_sid
        let memberSidRequest = NSMutableURLRequest(url: memberSidUrl!)
        self.addOperation(LDROperation(
            request: memberSidRequest as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!) }
                    //if object != nil { responseJSON = JSON(data: object as! Data) }
                }
            }
        ))

        // get cookies .LRC, .LH, .LL
        let sessionRequest = NSMutableURLRequest(url: URL(url: sessionUrl!, parameters: ["livedoor_id": username!, "password": password!])!)
        self.addOperation(LDROperation(
            request: sessionRequest as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!) }
                    //if object != nil { responseJSON = JSON(data: object as! Data) }
                }
            }
        ))

        // get reader_sid
        let readerSidRequest = NSMutableURLRequest(url: readerSidUrl!)
        self.addOperation(LDROperation(
            request: readerSidRequest as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if error != nil { completionHandler(nil, error!) }
                    //if object != nil { responseJSON = JSON(data: object as! Data) }
                    completionHandler(nil, nil)
                }
            }
        ))
    }

}
