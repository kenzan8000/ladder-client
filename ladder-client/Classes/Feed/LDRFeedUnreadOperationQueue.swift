import Foundation

// MARK: - LDRFeedUnreadOperationQueue
class LDRFeedUnreadOperationQueue: OperationQueue {

  // MARK: initializer

  override init() {
    super.init()
    maxConcurrentOperationCount = 5
  }

  // MARK: - destruction

  deinit {
    cancelAllOperations()
  }
}
