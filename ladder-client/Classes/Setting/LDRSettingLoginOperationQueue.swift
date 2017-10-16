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
     **/
    func start() {
        // no internet connection
        if Reachability.forInternetConnection().currentReachabilityStatus() == NotReachable {
            //LDRError.notReachable
            return
        }

        // no username
        let username = UserDefaults.standard.string(forKey: LDRUserDefaults.username)
        if username == nil {
            //LDRError.invalidUsername
            return
        }
        // no password
        let password = UserDefaults.standard.string(forKey: LDRUserDefaults.password)
        if password == nil {
            //LDRError.invalidPassword
            return
        }
        // no ldrurl
        let ldrUrlString = UserDefaults.standard.string(forKey: LDRUserDefaults.ldrUrlString)
        if ldrUrlString == nil {
            //LDRError.invalidLdrUrl
            return
        }

    }

}
