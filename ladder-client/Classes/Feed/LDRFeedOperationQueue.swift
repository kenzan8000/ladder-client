import Alamofire
import ISHTTPOperation
import KeychainAccess
import SwiftyJSON

// MARK: - LDRFeedOperationQueue
class LDRFeedOperationQueue: ISHTTPOperationQueue {

    // MARK: - property

    static let shared = LDRFeedOperationQueue()

    // MARK: - initialization

    override init() {
        super.init()
    }

    // MARK: - destruction

    deinit {
        self.cancelAllOperations()
    }

    // MARK: - public api

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
        guard let apiKey = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.apiKey] else {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        if apiKey.isEmpty {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        guard let url = LDRUrl(path: LDR.Api.subs, params: ["unread": "1"]) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        var headers = HTTPHeaders()
        if let cookieHeader = URLRequest.getCookies(host: url.host) {
            headers.add(cookieHeader)
        }
        headers.add(name: "Content-Type", value: "application/json")
        let httpBody = ["ApiKey": apiKey].HTTPBodyValue()
        headers.add(name: "Content-Length", value: "\(String(describing: httpBody?.count))")
        guard var request = try? URLRequest(
            url: url,
            method: HTTPMethod(rawValue: "POST"),
            headers: headers
        ) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }
        request.httpBody = httpBody

        self.addOperation(LDROperation(
            request: request,
            handler: { [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                if let r = response {
                    HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
                }
                var json = JSON([])
                do {
                    if let data = object as? Data {
                        json = try JSON(data: data)
                    }
                } catch {
                    self.cancelAllOperations()
                    LDRPinOperationQueue.shared.cancelAllOperations()
                    NotificationCenter.default.post(
                        name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
                        object: nil
                    )
                    completionHandler(nil, LDRError.invalidUrlOrUsernameOrPassword)
                    return
                }
                DispatchQueue.main.async {
                    if let e = error {
                        completionHandler(nil, e)
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
        guard let apiKey = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.apiKey] else {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        if apiKey.isEmpty {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        guard let url = LDRUrl(path: LDR.Api.unread) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        var headers = HTTPHeaders()
        if let cookieHeader = URLRequest.getCookies(host: url.host) {
            headers.add(cookieHeader)
        }
        headers.add(name: "Content-Type", value: "application/json")
        let httpBody = ["ApiKey": apiKey, "subscribe_id": subscribeId].HTTPBodyValue()
        headers.add(name: "Content-Length", value: "\(String(describing: httpBody?.count))")
        guard var request = try? URLRequest(
            url: url,
            method: HTTPMethod(rawValue: "POST"),
            headers: headers
        ) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }
        request.httpBody = httpBody
        
        self.addOperation(LDROperation(
            request: request,
            handler: { [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                if let r = response {
                    HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
                }
                var json = JSON([])
                do {
                    if let data = object as? Data {
                        json = try JSON(data: data)
                    }
                } catch {
                    self.cancelAllOperations()
                    LDRPinOperationQueue.shared.cancelAllOperations()
                    NotificationCenter.default.post(
                        name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
                        object: nil
                    )
                    completionHandler(nil, LDRError.invalidUrlOrUsernameOrPassword)
                    return
                }
                DispatchQueue.main.async {
                    if let e = error {
                        completionHandler(nil, e)
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
        guard let apiKey = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.apiKey] else {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        if apiKey.isEmpty {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        guard let url = LDRUrl(path: LDR.Api.touchAll) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        var headers = HTTPHeaders()
        if let cookieHeader = URLRequest.getCookies(host: url.host) {
            headers.add(cookieHeader)
        }
        headers.add(name: "Content-Type", value: "application/json")
        let httpBody = ["ApiKey": apiKey, "subscribe_id": subscribeId].HTTPBodyValue()
        headers.add(name: "Content-Length", value: "\(String(describing: httpBody?.count))")
        guard var request = try? URLRequest(
            url: url,
            method: HTTPMethod(rawValue: "POST"),
            headers: headers
        ) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }
        request.httpBody = httpBody

        self.addOperation(LDROperation(
            request: request,
            handler: { [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                if let r = response {
                    HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
                }
                var json = JSON([])
                do {
                    if let data = object as? Data {
                        json = try JSON(data: data)
                    }
                } catch {
                    self.cancelAllOperations()
                    LDRPinOperationQueue.shared.cancelAllOperations()
                    NotificationCenter.default.post(
                        name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
                        object: nil
                    )
                    completionHandler(nil, LDRError.invalidUrlOrUsernameOrPassword)
                    return
                }
                DispatchQueue.main.async {
                    if let e = error {
                        completionHandler(nil, e)
                        return
                    }
                    completionHandler(json, nil)
                }
            }
        ))
    }

}
