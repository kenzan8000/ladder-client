/*
import Foundation
import ISHTTPOperation

class LDROperation: ISHTTPOperation {

  enum State: String {
    case Ready, Executing, Finished

    var keyPath: String {
      "is" + rawValue
    }
  }

  var state = State.Ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }
}

extension LDROperation {

  override var isReady: Bool {
    super.isReady && state == .Ready
  }

  override var isExecuting: Bool {
    state == .Executing
  }

  override var isFinished: Bool {
    state == .Finished
  }

  override func start() {
    if let connection = Reachability.forInternetConnection() {
        if connection.currentReachabilityStatus() == NotReachable {
            state = .Finished
            return
        }
    }
    if isCancelled {
      state = .Finished
      return
    }
    main()
    state = .Executing
  }

  override func cancel() {
    state = .Finished
  }
}
*/
