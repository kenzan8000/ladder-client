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

        let memberSidRequest = NSMutableURLRequest(url: memberSidUrl!)
        let sessionRequest = NSMutableURLRequest(url: URL(url: sessionUrl!, parameters: ["livedoor_id": username!, "password": password!])!)
        let readerSidRequest = NSMutableURLRequest(url: readerSidUrl!)
    }

}
