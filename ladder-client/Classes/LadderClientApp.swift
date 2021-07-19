import Combine
import KeychainAccess
import SwiftUI

// MARK: - LadderClientApp
@main
struct LadderClientApp: App {
  // MARK: property
  
  @UIApplicationDelegateAdaptor var delegate: LDRAppDelegate
  
  private let storageProvider = LDRStorageProvider(name: LDR.coreData, group: LDR.group)
  private let keychain = LDRKeychainStore(service: LDR.service, group: LDR.group)
  private var willResignActiveCancellable: AnyCancellable?
  
  var body: some Scene {
    WindowGroup {
      LDRTabView(
        keychain: keychain,
        selected: LDRTabView.Tab.feed,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider, keychain: keychain)
      )
      .environmentObject(LDRLoginViewModel(keychain: keychain))
    }
  }
  
  // MARK: initializer
  
  init() {
    if keychain.reloadTimestamp == nil {
      keychain.updateReloadTimestamp()
    }
    willResignActiveCancellable = NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        LDRKeychainStore(service: LDR.service, group: LDR.group).updateReloadTimestamp()
      }
  }
}
