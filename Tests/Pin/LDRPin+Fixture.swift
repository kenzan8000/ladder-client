@testable import ladder_client

// MARK: - LDRPinRowContent
struct LDRPinRowContent: Pin, Hashable {
  let title: String
  
  static func fixture(
    title: String
  ) -> LDRPinRowContent {
    LDRPinRowContent(title: title)
  }
}
