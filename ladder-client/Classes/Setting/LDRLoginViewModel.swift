import SwiftUI

// MARK: - LDRLoginViewModel
final class LDRLoginViewModel: ObservableObject {
    
    // MARK: - model
    
    @Published private var login = LDRLogin()
    @Published var isLogingIn = false
    
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
    
    // MARK: - public api

    func startLogin() {
        if self.isLogingIn {
            return
        }
        self.isLogingIn = true
        login.start { [unowned self] _, _ in
            self.isLogingIn = false
        }
    }
}
