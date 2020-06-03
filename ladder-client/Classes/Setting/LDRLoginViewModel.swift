import SwiftUI

// MARK: - LDRLoginViewModel
class LDRLoginViewModel: ObservableObject {
    
    // MARK: - Model
    
    @Published private var login: LDRLogin<String> = LDRLoginViewModel.createLoginDomainUrl()

    static func createLoginDomainUrl() -> LDRLogin<String> {
        LDRLogin<String> {
            if let urlDomain = LDRRequestHelper.getLDRDomain() {
                return urlDomain
            }
            return ""
        }
    }
    
    // MARK: - Access to the Model
    
    var urlDomain: String {
        login.loginParam.domainUrl
    }
    
    var username: String {
        login.loginParam.username
    }
    
    var password: String {
        login.loginParam.password
    }
    
    // MARK: - Intent
    
}
