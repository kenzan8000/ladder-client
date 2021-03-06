import KeychainAccess

// MARK: - LDRKeychain
enum LDRKeychain {
  static let username = "LDRKeychain.username"
  static let password = "LDRKeychain.password"
  static let ldrUrlString = "LDRKeychain.ldrUrlString"
  static let apiKey = "LDRKeychain.apiKey"
  // static let session = "LDRKeychain.session"
}

// MARK: - String + LDRKeychain
extension String {
  static let ldrService = "org.kenzan8000.ladder-client"
  static let ldrGroup = "group.ladder-pin"
}

// MARK: - Keychain + LDR
extension Keychain {
  static let ldr = Keychain(service: .ldrService, accessGroup: .ldrGroup)
}
