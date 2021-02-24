import Foundation

// MARK: - Notification.Name
extension Notification.Name {
  static let ldrDidLogin = Notification.Name("Notification.ldrDidLogin")
  static let ldrWillCloseLoginView = Notification.Name("Notification.ldrWillCloseLoginView")
  static let ldrDidGetInvalidUrlOrUsernameOrPasswordError = Notification.Name("Notification.ldrDidGetInvalidUrlOrUsernameOrPasswordError")
}
