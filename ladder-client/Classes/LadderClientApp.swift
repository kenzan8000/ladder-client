import os
import SwiftUI

let logger = Logger(subsystem: "\(Bundle.main.bundleIdentifier ?? "").logger", category: "main")

// MARK: - LadderClientApp
@main
struct LadderClientApp: App {
  // MARK: property
  
  let storageProvider = LDRStorageProvider(name: .ldrCoreData, group: .ldrGroup)
  
  var body: some Scene {
    WindowGroup {
      LDRTabView(
        selected: LDRTabView.Tab.feed,
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
