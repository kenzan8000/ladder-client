import HTMLReader
import JavaScriptCore
import KeychainAccess
import MobileCoreServices
import SwiftyJSON
import UIKit

class ActionViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        var noUrlInfo = true
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    noUrlInfo = false
                    provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (data, error) in
                        OperationQueue.main.addOperation { [weak self] in
                            if let e = error {
                                self?.operationDidFail(error: e)
                                return
                            }
                            if let url = data as? URL {
                                self?.url = url
                                self?.activityIndicatorView.isHidden = false
                                self?.activityIndicatorView.startAnimating()
                                self?.start(completionHandler: { [weak self] (_ error: Error?) -> Void in
                                    if let e = error {
                                        self?.operationDidFail(error: e)
                                    }
                                    else {
                                        self?.operationDidSucceed()
                                    }
                                })
                                
                            }
                            else {
                                self?.operationDidFail(error: LDRError.invalidPinUrl)
                            }
                        }
                    })
                }
            }
        }
        if noUrlInfo {
            self.operationDidFail(error: LDRError.invalidPinUrl)
        }
    }

    @IBAction private func done() {
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    
    func start(completionHandler: @escaping (_ error: Error?) -> Void) {
        self.requestLogin(completionHandler: completionHandler)
    }
    
    func requestLogin(completionHandler: @escaping (_ error: Error?) -> Void) {
        // invalid username
        let username = Keychain(
            service: .ldrServiceName,
            accessGroup: .ldrSuiteName
        )[LDRKeychain.username]
        if username == nil || username! == "" { completionHandler(LDRError.invalidUsername); return }
        // invalid password
        let password = Keychain(
            service: .ldrServiceName,
            accessGroup: .ldrSuiteName
        )[LDRKeychain.password]
        if password == nil || password! == "" { completionHandler(LDRError.invalidPassword); return }
        // invalid url
        let url = LDRUrl(path: LDRApi.login, params: ["username": username!, "password": password!])
        //let url = LDRUrl(path: LDRApi.login)
        if url == nil { completionHandler(LDRError.invalidLdrUrl); return }

        // request
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(
            with: request,
            completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
                OperationQueue.main.addOperation { [weak self] in
                  guard let self = self else {
                    completionHandler(LDRError.failed("Failed for some reason."))
                    return
                  }
                    if error != nil { completionHandler(error!); return }
                    if data == nil { completionHandler(LDRError.invalidAuthenticityToken); return }
                  if let httpUrlResponse = response as? HTTPURLResponse { HTTPCookieStorage.shared.addCookies(urlResponse: httpUrlResponse) }

                    // parse html
                    let authenticityToken = self.getAuthencityToken(htmlData: data!)
                    if authenticityToken == nil { completionHandler(LDRError.invalidAuthenticityToken); return }
                
                    self.requestSession(authenticityToken: authenticityToken!, completionHandler: completionHandler)
                }
            }
        ).resume()
    }
    
    func requestSession(authenticityToken: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        // invalid username
        let username = Keychain(
            service: .ldrServiceName,
            accessGroup: .ldrSuiteName
        )[LDRKeychain.username]
        if username == nil || username! == "" { completionHandler(LDRError.invalidUsername); return }
        // invalid password
        let password = Keychain(
            service: .ldrServiceName,
            accessGroup: .ldrSuiteName
        )[LDRKeychain.password]
        if password == nil || password! == "" { completionHandler(LDRError.invalidPassword); return }
        // invalid url
        let url = URL(ldrPath: LDRApi.api.pin.add)

        // request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ["username": username!, "password": password!, "authenticity_token": authenticityToken].HTTPBodyValue()
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(
            with: request as URLRequest,
            completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in                OperationQueue.main.addOperation { [weak self] in
                   guard let self = self else {
                     completionHandler(LDRError.failed("Failed for some reason."))
                     return
                   }
                    if error != nil { completionHandler(error!); return }
                    if data == nil { completionHandler(LDRError.invalidApiKey); return }
              if let httpUrlResponse = response as? HTTPURLResponse { HTTPCookieStorage.shared.addCookies(urlResponse: httpUrlResponse) }

                    let authenticityToken = self.getAuthencityToken(htmlData: data!)
                    if authenticityToken != nil { completionHandler(LDRError.invalidUsernameOrPassword); return }

                    var apiKey = "undefined"
                    let document = HTMLDocument(data: data!, contentTypeHeader: nil)

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
                    if apiKey == "undefined" { completionHandler(LDRError.invalidApiKey); return }

                    Keychain(
                        service: .ldrServiceName,
                        accessGroup: .ldrSuiteName
                    )[LDRKeychain.apiKey] = apiKey
                
                  self.requestPinAdd(link: self.url!, title: self.url!.host!+self.url!.path, completionHandler: completionHandler)
                }
            }
        ).resume()
    }
    
    func requestPinAdd(link: URL, title: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        // invalid ApiKey
        let apiKey = Keychain(
            service: .ldrServiceName,
            accessGroup: .ldrSuiteName
        )[LDRKeychain.apiKey]
        if apiKey == nil || apiKey == "" { completionHandler(LDRError.invalidApiKey); return }
        // invalid url
        let url = URL(ldrPath: LDRApi.api.pin.add)

        // request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ["ApiKey": apiKey!, "title": title, "link": link.absoluteString].HTTPBodyValue()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }
        request.setCookies()

        URLSession.shared.dataTask(
            with: request as URLRequest,
            completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in                OperationQueue.main.addOperation {
                    if let e = error {
                        completionHandler(e)
                        return
                    }
                    guard let d = data else {
                        completionHandler(LDRError.invalidApiKey)
                        return
                    }
              if let httpUrlResponse = response as? HTTPURLResponse { HTTPCookieStorage.shared.addCookies(urlResponse: httpUrlResponse) }
                
                    do {
                        let json = try JSON(data: d)
                    }
                    catch {
                        completionHandler(LDRError.invalidUrlOrUsernameOrPassword)
                        return
                    }
                    completionHandler(nil)
                }
            }
        ).resume()
    }

    
    private func operationDidFail(error: Error) {
        self.label.text = error.localizedDescription
        if error is LDRError {
            self.label.text = "Check out your ladder-client settings and try again."
        }
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.isHidden = true
    }
    
    private func operationDidSucceed() {
        self.activityIndicatorView.stopAnimating()
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
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
