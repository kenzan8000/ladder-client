import Foundation
@testable import ladder_client

// MARK: - LDRKeychainStub
class LDRKeychainStub: LDRKeychain {
  // MARK: property
  
  private var keychain = [String: String]()
  
  var apiKey: String? {
    get { keychain["LDRKeychain.apiKey"] }
    set { keychain["LDRKeychain.apiKey"] = newValue }
  }
  
  var cookie: String? {
    get { keychain["LDRKeychain.cookie"] }
    set { keychain["LDRKeychain.cookie"] = newValue }
  }
  
  var ldrUrlString: String? {
    get { keychain["LDRKeychain.ldrUrlString"] }
    set { keychain["LDRKeychain.ldrUrlString"] = newValue }
  }
  
  var feedSubsUnreadSegmentString: String? {
    get { keychain["LDRKeychain.feedSubsUnreadSegmentString"] }
    set { keychain["LDRKeychain.feedSubsUnreadSegmentString"] = newValue }
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
