import SnapshotTesting
import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRPinRowTests
class LDRPinRowTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRPinRow_whenInitialState_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let sut = UIHostingController(
        rootView: LDRPinRow(viewModel: .init(pin: LDRPinRowContent.fixture(title: "Rails アプリでオンラインでカラムの削除やリネームを行うには - eagletmt's blog")))
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRPinRow_whenShortTitle_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let sut = UIHostingController(
        rootView: LDRPinRow(viewModel: .init(pin: LDRPinRowContent.fixture(title: "Rails - eagletmt's blog")))
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRPinRow_whenLongTitle_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let sut = UIHostingController(
        rootView: LDRPinRow(viewModel: .init(pin: LDRPinRowContent.fixture(title: "Rails アプリでオンラインでカラムの削除やリネームを行うには - eagletmt's blog あいうえお かきくけこ さしすせそ たちつてと あいうえお かきくけこ さしすせそ たちつてと")))
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
