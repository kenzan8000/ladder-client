import KeychainAccess
import os
import SwiftUI

let logger = Logger(subsystem: "\(Bundle.main.bundleIdentifier ?? "").logger", category: "main")

// MARK: - LadderClientApp
@main
struct LadderClientApp: App {
  // MARK: property
  
  var body: some Scene {
    WindowGroup {
      LDRTabView(
        loginViewModel: LDRLoginViewModel(),
        feedViewModel: LDRFeedViewModel(),
        pinViewModel: LDRPinViewModel()
      )
    }
  }
  
  // MARK: initialization
  
  init() {
    /*
    if let session = Keychain(service: .ldrServiceName, accessGroup: .ldrSuiteName)[LDRKeychain.session] {
      HTTPCookie.cookies(
        withResponseHeaderFields: ["Set-Cookie": "\(LDRApi.cookieName)=\(session)"],
        for: URL(ldrPath: LDRApi.login)
      ).forEach {
        HTTPCookieStorage.shared.setCookie($0)
      }
    }
    */
  }
}
