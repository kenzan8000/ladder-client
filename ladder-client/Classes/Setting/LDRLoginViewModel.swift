import SwiftUI

// MARK: - LDRLoginViewModel
class LDRLoginViewModel: ObservableObject {
    
    // MARK: - model
    
    @Published private var login: LDRLogin<String> = LDRLoginViewModel.createLoginDomainUrl()

    static func createLoginDomainUrl() -> LDRLogin<String> {
        LDRLogin<String> {
            if let urlDomain = LDRRequestHelper.getLDRDomain() {
                return urlDomain
            }
            return ""
        }
    }
    
    // MARK: - access to the model
    
    var urlDomain: String {
        login.loginParam.domainUrl
    }
    
    var username: String {
        login.loginParam.username
    }
    
    var password: String {
        login.loginParam.password
    }
    
    // MARK: - intent
    
    func update(domainUrl: String) {
        login.update(domainUrl: domainUrl)
    }
    
    func update(username: String) {
        login.update(username: username)
    }
    
    func update(password: String) {
        login.update(password: password)
    }
}
