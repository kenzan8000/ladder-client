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
    let sut = UIHostingController(
      rootView: LDRPinRow(title: "Rails アプリでオンラインでカラムの削除やリネームを行うには - eagletmt's blog")
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(on: .iPhone8, precision: 0.95, traits: .iPhone8(.portrait)),
        named: named
      )
      assertSnapshot(
        matching: sut,
        as: .recursiveDescription(on: .iPhone8),
        named: named
      )
    }
  }
  
  func testLDRPinRow_whenShortTitle_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: LDRPinRow(title: "Rails - eagletmt's blog")
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(on: .iPhone8, precision: 0.95, traits: .iPhone8(.portrait)),
        named: named
      )
      assertSnapshot(
        matching: sut,
        as: .recursiveDescription(on: .iPhone8),
        named: named
      )
    }
  }
  
  func testLDRPinRow_whenLongTitle_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: LDRPinRow(title: "Rails アプリでオンラインでカラムの削除やリネームを行うには - eagletmt's blog あいうえお かきくけこ さしすせそ たちつてと あいうえお かきくけこ さしすせそ たちつてと")
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(on: .iPhone8, precision: 0.95, traits: .iPhone8(.portrait)),
        named: named
      )
      assertSnapshot(
        matching: sut,
        as: .recursiveDescription(on: .iPhone8),
        named: named
      )
    }
  }

}
