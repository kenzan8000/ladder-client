import Foundation
import KeychainAccess

// MARK: - URL + LDR
extension URL {
  
  // MARK: initializer
  
  /// Inits
  /// - Parameters:
  ///   - ldrUrlString: base url that removes https:// (domain + path that runs fastladder rails app)
  ///   - ldrPath: url path string
  init(ldrUrlString: String?, ldrPath: String) {
    guard let ldrUrlString,
          URL(string: "https://" + ldrUrlString + ldrPath) != nil else {
      self.init(fileURLWithPath: "")
      return
    }
    // swiftlint:disable force_unwrapping
    self.init(string: "https://" + ldrUrlString + ldrPath)!
    // swiftlint:enable force_unwrapping
  }
}
