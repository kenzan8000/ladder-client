import Foundation
import KeychainAccess

// MARK: - LDRKeychain
enum LDRKeychain {
  static let ldrUrlString = "LDRKeychain.ldrUrlString"
  static let apiKey = "LDRKeychain.apiKey"
  private static let reloadTimestamp = "LDRKeychain.reloadTimestamp"
}

// MARK: - LDRKeychain + willResignActiveTimestamp
extension LDRKeychain {
  /// Returns if reload timestamp expired Bool value
  static func reloadTimestampExpired() -> Bool {
    Date() > Date(
      timeIntervalSince1970: Double(Keychain.ldr[LDRKeychain.reloadTimestamp] ?? "0.0") ?? 0.0
    )
  }
  
  /// Updates reloadTimestamp
  static func updateReloadTimestamp() {
    Keychain.ldr[LDRKeychain.reloadTimestamp] = String(Date().timeIntervalSince1970 + 3600.0)
  }
}

// MARK: - Keychain + LDR
extension Keychain {
  static let ldr = Keychain(service: LDR.service, accessGroup: LDR.group)
}
