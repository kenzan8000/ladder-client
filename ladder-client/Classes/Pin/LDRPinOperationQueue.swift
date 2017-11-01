// MARK: - LDRPinOperationQueue
class LDRPinOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let shared = LDRPinOperationQueue()


    /// MARK: - initialization

    override init() {
        super.init()

        self.maxConcurrentOperationCount = 3
    }


    /// MARK: - destruction

    deinit {
        self.cancelAllOperations()
    }


    /// MARK: - public api

}
