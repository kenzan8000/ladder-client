// MARK: - LDRApi
enum LDRApi {
  static let login = "/login"
  static let session = "/session"
  static let subscribe = "/subscribe"
  enum Api {
    static let subs = "/api/subs"
    static let unread = "/api/unread"
    static let touchAll = "/api/touch_all"
    static let pinAdd = "/api/pin/add"
    static let pinRemove = "/api/pin/remove"
    static let pinAll = "/api/pin/all"
  }
  static let cookieName = "_fastladder_session"
}
