import Alamofire
import ISHTTPOperation
import KeychainAccess
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
    
    /// request api/pin/add api
    ///
    /// - Parameters:
    ///   - link: pin url
    ///   - title: pin title
    ///   - completionHandler: handler called when request ends
    func requestPinAdd(
        link: URL,
        title: String,
        completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void
    ) {
        // invalid ApiKey
        let apiKey = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.apiKey]
        if apiKey == nil || apiKey == "" {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        guard let url = LDRUrl(path: LDR.api.pin.add) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        var headers = HTTPHeaders()
        if let cookieHeader = URLRequest.getCookies(host: url.host) {
            headers.add(cookieHeader)
        }
        headers.add(name: "Content-Type", value: "application/json")
        let httpBody = ["ApiKey": apiKey!, "title": title, "link": link.absoluteString].HTTPBodyValue()
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
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                if let r = response {
                    HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
                }
                var json = JSON([])
                do {
                    json = try JSON(data: object as! Data)
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
                    if let e = error {
                        completionHandler(nil, e)
                        return
                    }
                    completionHandler(json, nil)
                }
            }
        ))
    }

    /// request api/pin/remove api
    ///
    /// - Parameters:
    ///   - link: pin url
    ///   - completionHandler: handler called when request ends
    func requestPinRemove(
        link: URL,
        completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void
    ) {
        // invalid ApiKey
        let apiKey = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.apiKey]
        if apiKey == nil || apiKey == "" {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        guard let url = LDRUrl(path: LDR.api.pin.remove) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        var headers = HTTPHeaders()
        if let cookieHeader = URLRequest.getCookies(host: url.host) {
            headers.add(cookieHeader)
        }
        headers.add(name: "Content-Type", value: "application/json")
        let httpBody = ["ApiKey": apiKey!, "link": link.absoluteString].HTTPBodyValue()
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
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                if let r = response {
                    HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
                }
                var json = JSON([])
                do {
                    json = try JSON(data: object as! Data)
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
                    if let e = error {
                        completionHandler(nil, e)
                        return
                    }
                    completionHandler(json, nil)
                }
            }
        ))
    }
    
    /// request api/pin/all api
    ///
    /// - Parameter completionHandler: handler called when request ends
    func requestPinAll(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // invalid ApiKey
        let apiKey = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.apiKey]
        if apiKey == nil || apiKey == "" {
            completionHandler(nil, LDRError.invalidApiKey)
            return
        }
        // invalid url
        guard let url = LDRUrl(path: LDR.api.pin.all) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        var headers = HTTPHeaders()
        if let cookieHeader = URLRequest.getCookies(host: url.host) {
            headers.add(cookieHeader)
        }
        headers.add(name: "Content-Type", value: "application/json")
        let httpBody = ["ApiKey": apiKey!].HTTPBodyValue()
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
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                if let r = response {
                    HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
                }
                var json = JSON([])
                do {
                    json = try JSON(data: object as! Data)
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
