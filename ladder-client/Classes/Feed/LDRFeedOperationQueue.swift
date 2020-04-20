import ISHTTPOperation
import SwiftyJSON


// MARK: - LDRFeedOperationQueue
class LDRFeedOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let shared = LDRFeedOperationQueue()


    /// MARK: - initialization

    override init() {
        super.init()
    }


    /// MARK: - destruction

    deinit {
        self.cancelAllOperations()
    }


    /// MARK: - public api

    /// start operation
    ///
    /// - Parameter completionHandler: handler called when completed the operation
    func start(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        self.requestSubs(completionHandler: completionHandler)
    }

    /// request api/subs
    ///
    /// - Parameter completionHandler: handler called when completed the request
    func requestSubs(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // stop all feed operations
        self.cancelAllOperations()
        self.maxConcurrentOperationCount = 1

        // invalid ApiKey
        let apiKey = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.apiKey)
        if apiKey == nil || apiKey == "" {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        let url = LDRUrl(path: LDR.api.subs, params: ["unread": "1"])
        if url == nil {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ["ApiKey": apiKey!].HTTPBodyValue()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }
        request.setCookies()

        self.addOperation(LDROperation(
            request: request as URLRequest?,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                if response != nil { HTTPCookieStorage.shared.addCookies(httpUrlResponse: response) }
                var json = JSON([])
                do {
                    if object != nil {
                        json = try JSON(data: object as! Data)
                    }
                }
                catch {
                    self.cancelAllOperations()
                    LDRPinOperationQueue.shared.cancelAllOperations()
                    NotificationCenter.default.post(name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError, object: nil)
                    completionHandler(nil, LDRError.invalidUrlOrUsernameOrPassword)
                    return
                }
                DispatchQueue.main.async {
                    if error != nil {
                        completionHandler(nil, error!)
                        return
                    }
                    completionHandler(json, nil)
                }
            }
        ))
    }

    /// request api/unread
    ///
    /// - Parameters:
    ///   - subscribeId: subscribe id
    ///   - completionHandler: handler called when completed the request
    func requestUnread(
        subscribeId: String,
        completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void
    ) {
        self.maxConcurrentOperationCount = 5

        // invalid ApiKey
        let apiKey = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.apiKey)
        if apiKey == nil || apiKey == "" {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        let url = LDRUrl(path: LDR.api.unread)
        if url == nil {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ["ApiKey": apiKey!, "subscribe_id": subscribeId].HTTPBodyValue()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }
        request.setCookies()

        self.addOperation(LDROperation(
            request: request as URLRequest?,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                if response != nil { HTTPCookieStorage.shared.addCookies(httpUrlResponse: response) }
                var json = JSON([])
                do {
                    if object != nil {
                        json = try JSON(data: object as! Data)
                    }
                }
                catch {
                    self.cancelAllOperations()
                    LDRPinOperationQueue.shared.cancelAllOperations()
                    NotificationCenter.default.post(name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError, object: nil)
                    completionHandler(nil, LDRError.invalidUrlOrUsernameOrPassword)
                    return
                }
                DispatchQueue.main.async {
                    if error != nil {
                        completionHandler(nil, error!)
                        return
                    }
                    completionHandler(json, nil)
                }
            }
        ))
    }

     /// request api/touch_all
     ///
     /// - Parameters:
     ///   - subscribeId: subscribe id
     ///   - completionHandler: handler called when completed the request
    func requestTouchAll(
        subscribeId: String,
        completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void
    ) {
        self.maxConcurrentOperationCount = 5

        // invalid ApiKey
        let apiKey = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.apiKey)
        if apiKey == nil || apiKey == "" {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        let url = LDRUrl(path: LDR.api.touch_all)
        if url == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }

        // request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ["ApiKey": apiKey!, "subscribe_id": subscribeId].HTTPBodyValue()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }
        request.setCookies()

        self.addOperation(LDROperation(
            request: request as URLRequest?,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                if response != nil { HTTPCookieStorage.shared.addCookies(httpUrlResponse: response) }
                var json = JSON([])
                do {
                    if object != nil {
                        json = try JSON(data: object as! Data)
                    }
                }
                catch {
                    self.cancelAllOperations()
                    LDRPinOperationQueue.shared.cancelAllOperations()
                    NotificationCenter.default.post(name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError, object: nil)
                    completionHandler(nil, LDRError.invalidUrlOrUsernameOrPassword)
                    return
                }
                DispatchQueue.main.async {
                    if error != nil { completionHandler(nil, error!); return }
                    completionHandler(json, nil)
                }
            }
        ))
    }

}
