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
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let sut = UIHostingController(
        rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedSubsUnreadPlaceholder.fixture(state: .unloaded)))
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenUnread_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let sut = UIHostingController(
        rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedSubsUnreadPlaceholder.fixture(state: .unread)))
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenRead_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let sut = UIHostingController(
        rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedSubsUnreadPlaceholder.fixture(state: .read)))
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenUnloadedAndLongTitle_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let sut = UIHostingController(
        rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedSubsUnreadPlaceholder.fixture(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", state: .unloaded)))
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenUnreadAndLongTitle_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let sut = UIHostingController(
        rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedSubsUnreadPlaceholder.fixture(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", state: .unread)))
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRFeedRow_whenReadAngLongTitle_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let sut = UIHostingController(
        rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedSubsUnreadPlaceholder.fixture(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", state: .read)))
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
}
