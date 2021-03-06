import Foundation
import KeychainAccess

// MARK: - URL + LDR
extension URL {
  
  // MARK: initialization
  
  /// Inits
  /// - Parameter path: url path
  init(ldrPath: String) {
    guard let ldrUrlString = Keychain.ldr[LDRKeychain.ldrUrlString] else {
      self.init(fileURLWithPath: "")
      return
    }
    // swiftlint:disable force_unwrapping
    self.init(string: "https://" + ldrUrlString + "\(ldrPath)")!
    // swiftlint:enable force_unwrapping
  }
}
