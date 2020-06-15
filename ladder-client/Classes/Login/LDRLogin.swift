import SwiftyJSON
import SwiftUI

// MARK: - LDRLogin
struct LDRLogin {
    
    // MARK: - property
    
    var loginParam: LDRLoginParam
    
    // MARK: - initialization
    
    init() {
        if let urlDomain = LDRRequestHelper.getLDRDomain() {
            self.loginParam = LDRLoginParam(domainUrl: urlDomain)
        } else {
            self.loginParam = LDRLoginParam(domainUrl: "")
        }
    }

    // MARK: - mutating

    mutating func update(domainUrl: String) {
        loginParam.domainUrl = domainUrl
    }
    
    mutating func update(username: String) {
        loginParam.username = username
    }
    
    mutating func update(password: String) {
        loginParam.password = password
    }
    
    /// start login operation
    /// - Parameter completionHandler: handler called when operation is completed
    mutating func start(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
        LDRRequestHelper.setUsername(loginParam.username)
        LDRRequestHelper.setPassword(loginParam.password)
        LDRRequestHelper.setURLDomain(loginParam.domainUrl)
        
        LDRLoginOperationQueue.shared.start(completionHandler: completionHandler)
    }
    
    // MARK: - public api
    
    /// end login operation
    func end() {
        LDRLoginOperationQueue.shared.cancelAllOperations()
    }
    
    // MARK: - LDRLoginParam
    struct LDRLoginParam {
        var domainUrl: String
        var username = ""
        var password = ""
    }

}
