import Combine
import KeychainAccess
import os
import SwiftUI

let logger = Logger(subsystem: "\(Bundle.main.bundleIdentifier ?? "").logger", category: "main")

// MARK: - LadderClientApp
@main
struct LadderClientApp: App {
  // MARK: property
  
  private let storageProvider = LDRStorageProvider(name: LDR.coreData, group: LDR.group)
  private var willResignActiveCancellable: AnyCancellable?
  
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
    if Keychain.ldr[LDRKeychain.reloadTimestamp] == nil {
      LDRKeychain.updateReloadTimestamp()
    }
    willResignActiveCancellable = NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        LDRKeychain.updateReloadTimestamp()
      }
  }
}
