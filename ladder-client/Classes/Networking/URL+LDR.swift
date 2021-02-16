import KeychainAccess

// MARK: - URL + LDR
extension URL {
  
  // MARK: initialization
  
  /// Inits
  /// - Parameter path: url path
  init(ldrPath: String) {
    guard let ldrUrlString = Keychain(
      service: LDRKeychain.serviceName,
      accessGroup: LDRKeychain.suiteName
    )[LDRKeychain.ldrUrlString] else {
      preconditionFailure("Couldn't retrieve RSS Reader URL.")
    }
    // swiftlint:disable force_unwrapping
    self.init(string: "https://" + ldrUrlString + "\(ldrPath)")!
    // swiftlint:enable force_unwrapping
  }
}
