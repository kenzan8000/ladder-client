import Foundation
import KeychainAccess

// MARK: - LDRKeychain
protocol LDRKeychain {
  var ldrUrlString: String? { get set }
  var apiKey: String? { get set }
  var reloadTimestamp: String? { get set }
  var reloadTimestampIsExpired: Bool { get }
  
  func updateReloadTimestamp()
}

// MARK: - LDRKeychainStore
class LDRKeychainStore: LDRKeychain {
  // MARK: property
  
  let service: String
  let group: String
  private var keychain: Keychain {
    Keychain(service: service, accessGroup: group)
  }
  
  var apiKey: String? {
    get { keychain["LDRKeychain.apiKey"] }
    set { keychain["LDRKeychain.apiKey"] = newValue }
  }
  
  var ldrUrlString: String? {
    get { keychain["LDRKeychain.ldrUrlString"] }
    set { keychain["LDRKeychain.ldrUrlString"] = newValue }
  }
  
  var feedSubsUnreadSegmentString: String? {
    get { keychain["LDRKeychain.feedSubsUnreadSegment"] }
    set { keychain["LDRKeychain.feedSubsUnreadSegment"] = newValue }
  }
  
  var reloadTimestamp: String? {
    get { keychain["LDRKeychain.reloadTimestamp"] }
    set { keychain["LDRKeychain.reloadTimestamp"] = newValue }
  }
  var reloadTimestampIsExpired: Bool {
    Date() > Date(timeIntervalSince1970: Double(reloadTimestamp ?? "0.0") ?? 0.0)
  }
  
  // MARK: initializer
  
  init(service: String, group: String) {
    self.service = service
    self.group = group
  }
  
  // MARK: public api
  
  /// Updates reloadTimestamp
  func updateReloadTimestamp() {
    reloadTimestamp = String(Date().timeIntervalSince1970 + 3600.0)
  }
}
