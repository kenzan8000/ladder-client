import SwiftyJSON
import SwiftUI

// MARK: - LDRLogin
struct LDRLogin<LDRLoginDomainUrl> {
    
    // MARK: - property
    
    var loginParam: LDRLoginParam
    var isLoginingIn = false
    
    // MARK: - initialization
    
    init(loginDomainUrlFactory: () -> String) {
        self.loginParam = LDRLoginParam(domainUrl: loginDomainUrlFactory())
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
    
    mutating func startLogin() {
        if isLoginingIn {
            return
        }
        isLoginingIn = true
        LDRRequestHelper.setUsername(loginParam.username)
        LDRRequestHelper.setPassword(loginParam.password)
        LDRRequestHelper.setURLDomain(loginParam.domainUrl)
        
        LDRSettingLoginOperationQueue.shared.start { (json: JSON?, error: Error?) -> Void in
            if let error = error {
                LDRLOG(error.localizedDescription)
                // let message = LDRErrorMessage(error: error)
            } else {
                if let json = json {
                    LDRLOG(json.debugDescription)
                }
            }
        }
    }
    
    // MARK: - LDRLoginParam

    struct LDRLoginParam {
        var domainUrl: String
        var username = ""
        var password = ""
    }

}
