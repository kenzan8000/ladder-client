import KeychainAccess

// MARK: - LDRKeychain
enum LDRKeychain {
  static let uuid = "LDRKeychain.uuid"
  static let username = "LDRKeychain.username"
  static let password = "LDRKeychain.password"
  static let ldrUrlString = "LDRKeychain.ldrUrlString"
  static let apiKey = "LDRKeychain.apiKey"
  static let session = "LDRKeychain.session"
  static let darkMode = "LDRKeychain.darkMode"
}

// MARK: - String + LDRKeychain
extension String {
  static let ldrServiceName = "org.kenzan8000.ladder-client"
  static let ldrSuiteName = "group.ladder-pin"
}
