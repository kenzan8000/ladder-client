import SwiftUI

// MARK: - LDRLogin
struct LDRLogin<LDRLoginDomainUrl> where LDRLoginDomainUrl: Equatable {
    
    // MARK: - property
    
    var loginParam: LDRLoginParam
    
    // MARK: - initialization
    
    init(loginDomainUrlFactory: () -> LDRLoginDomainUrl) {
        self.loginParam = LDRLoginParam(domainUrl: loginDomainUrlFactory())
    }

    struct LDRLoginParam {
        var domainUrl: LDRLoginDomainUrl
        var username = ""
        var password = ""
    }

}
