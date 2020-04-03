import ISHTTPOperation
import SwiftyJSON


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

    /**
     * request api/pin/add
     * @param link URL
     * @param title String
     * @param completionHandler (json: JSON?, error: Error?) -> Void
     **/
    func requestPinAdd(
        link: URL,
        title: String,
        completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void
    ) {
        // invalid ApiKey
        let apiKey = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.apiKey)
        if apiKey == nil || apiKey == "" {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        let url = LDRUrl(path: LDR.api.pin.add)
        if url == nil {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ["ApiKey": apiKey!, "title": title, "link": link.absoluteString].HTTPBodyValue()
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
                    LDRFeedOperationQueue.shared.cancelAllOperations()
                    NotificationCenter.default.post(
                        name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
                        object: nil
                    )
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

    /**
     * request api/pin/remove
     * @param link URL
     * @param completionHandler (json: JSON?, error: Error?) -> Void
     **/
    func requestPinRemove(
        link: URL,
        completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void
    ) {
        // invalid ApiKey
        let apiKey = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.apiKey)
        if apiKey == nil || apiKey == "" {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        let url = LDRUrl(path: LDR.api.pin.remove)
        if url == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }

        // request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ["ApiKey": apiKey!, "link": link.absoluteString].HTTPBodyValue()
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
                    LDRFeedOperationQueue.shared.cancelAllOperations()
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

    /**
     * request api/pin/all
     * @param completionHandler (json: JSON?, error: Error?) -> Void
     **/
    func requestPinAll(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // invalid ApiKey
        let apiKey = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.apiKey)
        if apiKey == nil || apiKey == "" {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        let url = LDRUrl(path: LDR.api.pin.all)
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
                    LDRFeedOperationQueue.shared.cancelAllOperations()
                    NotificationCenter.default.post(
                        name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
                        object: nil
                    )
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
}
