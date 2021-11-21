import Combine
import KeychainAccess
import SwiftUI

// MARK: - LDRApp
// swiftlint:disable convenience_type
@main
struct LDRApp {
  static func main() throws {
    if NSClassFromString("XCTestCase") == nil {
      LadderClientApp.main()
    } else {
      LDRTestApp.main()
    }
  }
}
// swiftlint:enable convenience_type

// MARK: - LadderClientApp
struct LadderClientApp: App {
  // MARK: property
  
  private let storageProvider = LDRStorageProvider(name: LDR.coreData, group: LDR.group)
  private let keychain = LDRKeychainStore(service: LDR.service, group: LDR.group)
  private var willResignActiveCancellable: AnyCancellable?
  
  var body: some Scene {
    WindowGroup {
      LDRTabView(
        keychain: keychain,
        selected: LDRTabView.Tab.feed,
        feedViewModel: .init(storageProvider: storageProvider, keychain: keychain, segment: .rate),
        pinViewModel: .init(storageProvider: storageProvider, keychain: keychain)
      )
      .environmentObject(LDRLoginView.ViewModel(keychain: keychain))
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

// MARK: - LDRTestApp
struct LDRTestApp: App {
  var body: some Scene {
    WindowGroup { Text("Running Tests") }
  }
}
