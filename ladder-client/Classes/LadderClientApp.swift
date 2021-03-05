import KeychainAccess
import os
import SwiftUI

let logger = Logger(subsystem: "\(Bundle.main.bundleIdentifier ?? "").logger", category: "main")

// MARK: - LadderClientApp
@main
struct LadderClientApp: App {
  // MARK: property
  
  let storageProvider = LDRStorageProvider()
  
  var body: some Scene {
    WindowGroup {
      LDRTabView(
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider)
      )
      .environmentObject(LDRLoginViewModel())
    }
  }
  
  // MARK: initialization
  
  init() {
  }
}
