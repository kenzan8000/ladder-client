import Foundation

// MARK: - Notification.Name
extension Notification.Name {
    static let ldrDidLogin = Notification.Name("\(Bundle.main.bundleIdentifier ?? "").ldrDidLogin")
    static let ldrWillCloseLoginView = Notification.Name("\(Bundle.main.bundleIdentifier ?? "").ldrWillCloseLoginView")
}
