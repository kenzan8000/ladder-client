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
      rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedRowContent.fixture(state: .unloaded)))
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
      rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedRowContent.fixture(state: .unread)))
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
      rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedRowContent.fixture(state: .read)))
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
      rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedRowContent.fixture(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", state: .unloaded)))
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
      rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedRowContent.fixture(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", state: .unread)))
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
      rootView: LDRFeedRow(viewModel: .init(subsunread: LDRFeedRowContent.fixture(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", state: .read)))
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
