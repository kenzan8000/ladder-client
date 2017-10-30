// MARK: - LDRPinOperationQueue
class LDRPinOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let shared = LDRPinOperationQueue()


    /// MARK: - initialization

    override init() {
        super.init()

        LDRPinOperationQueue.default().maxConcurrentOperationCount = 3
    }


    /// MARK: - destruction

    deinit {
        LDRPinOperationQueue.default().cancelAllOperations()
    }


    /// MARK: - public api

//    /**
//     * start
//     * @param completionHandler (json: JSON?, error: Error?) -> Void
//     **/
//    func start(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
//        LDRPinOperationQueue.default().cancelAllOperations()
//    }

}
