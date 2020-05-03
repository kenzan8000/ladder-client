import Alamofire
import HTMLReader
import ISHTTPOperation
import JavaScriptCore
import KeychainAccess
import SwiftyJSON


// MARK: - LDRSettingLoginOperationQueue
class LDRSettingLoginOperationQueue: ISHTTPOperationQueue {

    /// MARK: - property

    static let shared = LDRSettingLoginOperationQueue()


    /// MARK: - initialization

    override init() {
        super.init()

        self.maxConcurrentOperationCount = 1
    }


    /// MARK: - destruction

    deinit {
        self.cancelAllOperations()
    }


    /// MARK: - public api

    /// start login
    ///
    /// - Parameter completionHandler: handler called when operation ends
    func start(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // stop all network connections
        LDRFeedOperationQueue.shared.cancelAllOperations()
        LDRPinOperationQueue.shared.cancelAllOperations()
        self.cancelAllOperations()

        // delete cookies
        let url = LDRUrl(path: LDR.login)
        if url == nil { completionHandler(nil, LDRError.invalidLdrUrl); return }
        for cookieName in [LDR.cookieName] {
            HTTPCookieStorage.shared.deleteCookie(name: cookieName, domain: url!.host!)
        }

        // request login
        self.requestLogin(completionHandler: completionHandler)
    }
    
    /// request login
    ///
    /// - Parameter completionHandler: handler called when request ends
    func requestLogin(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        // invalid username
        let username = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.username]
        if username == nil || username! == "" {
            completionHandler(nil, LDRError.invalidUsername)
            return
        }
        // invalid password
        let password = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.password]
        if password == nil || password! == "" {
            completionHandler(nil, LDRError.invalidPassword)
            return
        }
        // invalid url
        guard let url = LDRUrl(
            path: LDR.login,
            params: ["username": username!, "password": password!]
        ) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        let request = URLRequest(url: url)
        self.addOperation(LDROperation(
            request: request as URLRequest?,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if let e = error {
                        completionHandler(nil, e)
                        return
                    }
                    if !(object is Data) {
                        completionHandler(nil, LDRError.invalidAuthenticityToken)
                        return
                    }
                    if let r = response {
                        HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
                    }

                    // parse html
                    guard let authenticityToken = self.getAuthencityToken(htmlData: object as! Data) else {
                        completionHandler(nil, LDRError.invalidAuthenticityToken)
                        return
                    }

                    self.requestSession(
                        authenticityToken: authenticityToken,
                        completionHandler: completionHandler
                    )
                }
            }
        ))
    }
    
    /// request session
    ///
    /// - Parameters:
    ///   - authenticityToken: authenticity token
    ///   - completionHandler: handler called when request ends
    func requestSession(
        authenticityToken: String,
        completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void
    ) {
        // invalid username
        let username = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.username]
        if username == nil || username! == "" {
            completionHandler(nil, LDRError.invalidUsername)
            return
        }
        // invalid password
        let password = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.password]
        if password == nil || password! == "" {
            completionHandler(nil, LDRError.invalidPassword)
            return
        }
        // invalid url
        guard let url = LDRUrl(path: LDR.session) else {
            completionHandler(nil, LDRError.invalidLdrUrl)
            return
        }

        // request
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        let httpBody = ["username": username!, "password": password!, "authenticity_token": authenticityToken].HTTPBodyValue()
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
            request: request as URLRequest?,
            handler:{ [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
                DispatchQueue.main.async { [unowned self] in
                    if let e = error {
                        completionHandler(nil, e)
                        return
                    }
                    if !(object is Data) {
                        completionHandler(nil, LDRError.invalidApiKey)
                        return
                    }
                    if let r = response {
                        HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
                    }

                    if let _ = self.getAuthencityToken(htmlData: object as! Data) {
                        completionHandler(nil, LDRError.invalidUsernameOrPassword)
                        return
                    }

                    var apiKey = "undefined"
                    let document = HTMLDocument(data: object as! Data, contentTypeHeader: nil)

                    let scripts = document.nodes(matchingSelector: "script")
                    for script in scripts {
                        for child in script.children {
                            if !(child is HTMLNode) { continue }

                            // parse ApiKey
                            let jsText = (child as! HTMLNode).textContent
                            let jsContext = JSContext()!
                            jsContext.evaluateScript(jsText)
                            jsContext.evaluateScript("var getApiKey = function() { return ApiKey; };")
                            // save ApiKey
                            apiKey = jsContext.evaluateScript("getApiKey();").toString()
                            if apiKey == "undefined" { continue }
                            break
                        }
                        if apiKey != "undefined" { break }
                    }
                    if apiKey == "undefined" {
                        completionHandler(nil, LDRError.invalidApiKey)
                        return
                    }

                    Keychain(
                        service: LDRKeychain.serviceName,
                        accessGroup: LDRKeychain.suiteName
                    )[LDRKeychain.apiKey] = apiKey
                    
                    completionHandler(nil, nil)
                    NotificationCenter.default.post(name: LDRNotificationCenter.didLogin, object: nil)
                }
            }
        ))
    }


    /// MARK: - private api
   
    /// returns authenticity_token from html
    ///
    /// - Parameter htmlData: data of html that contains authenticity_token
    /// - Returns: authenticity_token
    private func getAuthencityToken(htmlData: Data) -> String? {
        var authenticityToken: String? = nil
        let document = HTMLDocument(data: htmlData, contentTypeHeader: nil)
        let form = document.firstNode(matchingSelector: "form")
        if form == nil { return authenticityToken }
        for child in form!.children {
            if !(child is HTMLElement) { continue }
            if (child as! HTMLElement)["name"] != "authenticity_token" { continue }
            if !((child as! HTMLElement)["value"] != nil) { continue }
            authenticityToken = (child as! HTMLElement)["value"]
            break
        }
        return authenticityToken
    }

}
