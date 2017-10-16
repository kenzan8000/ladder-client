// MARK: - LDRSettingLoginOperationQueue
class LDRSettingLoginOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property
    var username: String = ""
    var password: String = ""


    /// MARK: - initialization

    /**
     * create login operation
     * @param username ldr username string
     * @param password ldr password string
     */
    init(username: string, password: string) {
        VGMapDataDownloadOperationQueue.default().maxConcurrentOperationCount = 1
/*
        // request
        let queries = [ "auth" : VGFirebase.Database.AuthToken ]
        let request = NSMutableURLRequest(url: URL(
                URLString: VGFirebase.API.DataJSON,
                queries: queries as Dictionary<String, String>
            )!
        )
        // execute
        let operation = ISHTTPOperation(
            request: request as URLRequest!,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                var responseJSON = JSON([:])
                if object != nil { responseJSON = JSON(data: object as! Data) }

                DispatchQueue.main.async { [unowned self] in
                    if error != nil { self.errorDownloading(error: error!); return }

                    self.updateModels(json: responseJSON, error: error)
                }
            }
        )
        VGMapDataDownloadOperationQueue.default().addOperation(operation!)
*/
        self.init()
    }


    /// MARK: - destruction

    deinit {
        LDRSettingLoginOperationQueue.default().cancelAllOperations()
    }

}
