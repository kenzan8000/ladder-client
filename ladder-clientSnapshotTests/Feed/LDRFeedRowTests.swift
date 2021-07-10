import SnapshotTesting
import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRFeedRowTests
class LDRFeedRowTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRFeedRow_whenUnloaded_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: LDRFeedRow(
        title: "はてなブックマーク - お気に入り",
        unreadCount: "187",
        color: .gray
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenUnread_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: LDRFeedRow(
        title: "はてなブックマーク - お気に入り",
        unreadCount: "187",
        color: .blue
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenRead_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: LDRFeedRow(
        title: "はてなブックマーク - お気に入り",
        unreadCount: "",
        color: .gray
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenUnloadedAndLongTitle_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: LDRFeedRow(
        title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り",
        unreadCount: "187",
        color: .gray
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenUnreadAndLongTitle_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: LDRFeedRow(
        title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り",
        unreadCount: "187",
        color: .blue
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenReadAngLongTitle_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: LDRFeedRow(
        title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り",
        unreadCount: "",
        color: .gray
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
}
