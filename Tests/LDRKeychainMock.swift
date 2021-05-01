import Foundation
@testable import ladder_client

// MARK: - LDRKeychainMock
class LDRKeychainMock: LDRKeychain {
  // MARK: property
  
  private var keychain = [String: String]()
  
  var ldrUrlString: String? {
    get { keychain["LDRKeychain.ldrUrlString"] }
    set { keychain["LDRKeychain.ldrUrlString"] = newValue }
  }
  
  var apiKey: String? {
    get { keychain["LDRKeychain.apiKey"] }
    set { keychain["LDRKeychain.apiKey"] = newValue }
  }
  
  var reloadTimestamp: String? {
    get { keychain["LDRKeychain.reloadTimestamp"] }
    set { keychain["LDRKeychain.reloadTimestamp"] = newValue }
  }
  var reloadTimestampIsExpired: Bool {
    Date() > Date(timeIntervalSince1970: Double(reloadTimestamp ?? "0.0") ?? 0.0)
  }
  
  // MARK: public api
  
  /// Updates reloadTimestamp
  func updateReloadTimestamp() {
    reloadTimestamp = String(Date().timeIntervalSince1970 + 3600.0)
  }
}
