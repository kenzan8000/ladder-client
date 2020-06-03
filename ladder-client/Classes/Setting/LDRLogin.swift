import SwiftUI

// MARK: - LDRLogin
struct LDRLogin<LDRLoginDomainUrl> where LDRLoginDomainUrl: Equatable {
    
    // MARK: - property
    
    var loginParam: LDRLoginParam
    
    // MARK: - initialization
    
    init(loginDomainUrlFactory: () -> LDRLoginDomainUrl) {
        self.loginParam = LDRLoginParam(domainUrl: loginDomainUrlFactory())
    }

    // MARK: - mutating

    mutating func update(domainUrl: LDRLoginDomainUrl) {
        loginParam.domainUrl = domainUrl
    }
    
    mutating func update(username: String) {
        loginParam.username = username
    }
    
    mutating func update(password: String) {
        loginParam.password = password
    }
    
    // MARK: - mutating

    struct LDRLoginParam {
        var domainUrl: LDRLoginDomainUrl
        var username = ""
        var password = ""
    }

}
