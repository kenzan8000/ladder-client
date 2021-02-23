import Alamofire
import ISHTTPOperation
import SwiftyJSON

// MARK: - LDRFeedUnreadOperationQueue
class LDRFeedUnreadOperationQueue: ISHTTPOperationQueue {

  // MARK: initialization

  override init() {
    super.init()
    maxConcurrentOperationCount = 5
  }

  // MARK: - destruction

  deinit {
    cancelAllOperations()
  }
}
