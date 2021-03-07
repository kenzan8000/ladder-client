import KeychainAccess

// MARK: - LDRKeychain
enum LDRKeychain {
  static let username = "LDRKeychain.username"
  static let password = "LDRKeychain.password"
  static let ldrUrlString = "LDRKeychain.ldrUrlString"
  static let apiKey = "LDRKeychain.apiKey"
}

// MARK: - Keychain + LDR
extension Keychain {
  static let ldr = Keychain(service: LDR.service, accessGroup: LDR.group)
}
