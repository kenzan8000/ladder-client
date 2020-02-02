import UIKit
import JavaScriptCore
import MobileCoreServices
import SwiftyJSON
import HTMLReader

class ActionViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (data, error) in
                        OperationQueue.main.addOperation { [unowned self] in
                            if let e = error {
                                return
                            }
                            if let url = data as? URL {
                                self.url = url
                                self.activityIndicatorView.startAnimating()
                            }
                            else {
                            }
                        }
                    })
                }
            }
        }
    }

    @IBAction func done() {
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    func requestLogin(completionHandler: @escaping (_ error: Error?) -> Void) {
        // invalid username
        let username = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.username)
        if username == nil || username! == "" { completionHandler(LDRError.invalidUsername); return }
        // invalid password
        let password = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.password)
        if password == nil || password! == "" { completionHandler(LDRError.invalidPassword); return }
        // invalid url
        let url = LDRUrl(path: LDR.login, params: ["username": username!, "password": password!])
        //let url = LDRUrl(path: LDR.login)
        if url == nil { completionHandler(LDRError.invalidLdrUrl); return }

        // request
        let request = NSMutableURLRequest(url: url!)
        URLSession.shared.dataTask(
            with: request as URLRequest,
            completionHandler: { [unowned self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
                OperationQueue.main.addOperation { [unowned self] in
                    if error != nil { completionHandler(error!); return }
                    if data == nil { completionHandler(LDRError.invalidAuthenticityToken); return }
                    if let httpUrlResponse = response as? HTTPURLResponse { HTTPCookieStorage.shared.addCookies(httpUrlResponse: httpUrlResponse) }

                    // parse html
                    let authenticityToken = self.getAuthencityToken(htmlData: data!)
                    if authenticityToken == nil { completionHandler(LDRError.invalidAuthenticityToken); return }
                
                    self.requestSession(authenticityToken: authenticityToken!, completionHandler: completionHandler)
                }
            }
        )
    }
    
    func requestSession(authenticityToken: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        // invalid username
        let username = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.username)
        if username == nil || username! == "" { completionHandler(LDRError.invalidUsername); return }
        // invalid password
        let password = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.password)
        if password == nil || password! == "" { completionHandler(LDRError.invalidPassword); return }
        // invalid url
        let url = LDRUrl(path: LDR.session)
        if url == nil { completionHandler(LDRError.invalidLdrUrl); return }

        // request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ["username": username!, "password": password!, "authenticity_token": authenticityToken].HTTPBodyValue()
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(
            with: request as URLRequest,
            completionHandler: { [unowned self] (data: Data?, response: URLResponse?, error: Error?) -> Void in                OperationQueue.main.addOperation { [unowned self] in
                    if error != nil { completionHandler(error!); return }
                    if data == nil { completionHandler(LDRError.invalidApiKey); return }
                    if let httpUrlResponse = response as? HTTPURLResponse { HTTPCookieStorage.shared.addCookies(httpUrlResponse: httpUrlResponse) }

                    let authenticityToken = self.getAuthencityToken(htmlData: data!)
                    if authenticityToken != nil { completionHandler(LDRError.invalidUsernameOrPassword); return }

                    var apiKey = "undefined"
                    let document = HTMLDocument(data: data!, contentTypeHeader: nil)

                    let scripts = document.nodes(matchingSelector: "script")
                    if scripts == nil { completionHandler(LDRError.invalidApiKey); return }
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

                    UserDefaults(suiteName: LDRUserDefaults.suiteName)?.setValue(apiKey, forKey: LDRUserDefaults.apiKey)
                    UserDefaults(suiteName: LDRUserDefaults.suiteName)?.synchronize()
                    self.requestPinAdd(link: self.url!, title: "\(self.url!.host)", completionHandler: completionHandler)
                }
            }
        )
    }
    
    func requestPinAdd(link: URL, title: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        // invalid ApiKey
        let apiKey = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.apiKey)
        if apiKey == nil || apiKey == "" { completionHandler(LDRError.invalidApiKey); return }
        // invalid url
        let url = LDRUrl(path: LDR.api.pin.add)
        if url == nil { completionHandler(LDRError.invalidLdrUrl); return }

        // request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = ["ApiKey": apiKey!, "title": title, "link": link.absoluteString].HTTPBodyValue()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if request.httpBody != nil { request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length") }
        request.setCookies()

        URLSession.shared.dataTask(
            with: request as URLRequest,
            completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in                OperationQueue.main.addOperation {
                    if error != nil { completionHandler(error!); return }
                    if data == nil { completionHandler(LDRError.invalidApiKey); return }
                    if let httpUrlResponse = response as? HTTPURLResponse { HTTPCookieStorage.shared.addCookies(httpUrlResponse: httpUrlResponse) }
                
                    do {
                        try JSON(data: data!)
                    }
                    catch {
                        completionHandler(LDRError.invalidUrlOrUsernameOrPassword)
                        return
                    }
                    completionHandler(nil)
                }
            }
        )
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
