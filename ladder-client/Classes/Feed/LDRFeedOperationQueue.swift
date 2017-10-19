// MARK: - LDRFeedOperationQueue
class LDRFeedOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let shared = LDRFeedOperationQueue()


    /// MARK: - initialization

    override init() {
        super.init()

        LDRFeedOperationQueue.default().maxConcurrentOperationCount = 5
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
    }

}
