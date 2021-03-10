import SnapshotTesting
import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRTabViewTests
class LDRTabViewTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRTabView_whenSelectedTabIsFeedAndSegmentIsRate_snapshotTesting() throws {
    let storageProvider = LDRStorageProvider(source: Bundle(for: type(of: LDRTabViewTests())), name: LDR.coreData, group: LDR.testGroup)
    let sut = UIHostingController(
      rootView: LDRTabView(
        selected: LDRTabView.Tab.feed,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, segment: .rate),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider)
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(on: .iPhone8, precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
  
  func testLDRTabView_whenSelectedTabIsFeedAndSegmentIsFolder_snapshotTesting() throws {
    let storageProvider = LDRStorageProvider(source: Bundle(for: type(of: LDRTabViewTests())), name: LDR.coreData, group: LDR.testGroup)
    let sut = UIHostingController(
      rootView: LDRTabView(
        selected: LDRTabView.Tab.feed,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, segment: .folder),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider)
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(on: .iPhone8, precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
  
  func testLDRTabView_whenSelectedTabIsPin_snapshotTesting() throws {
    let storageProvider = LDRStorageProvider(source: Bundle(for: type(of: LDRTabViewTests())), name: LDR.coreData, group: LDR.testGroup)
    let sut = UIHostingController(
      rootView: LDRTabView(
        selected: LDRTabView.Tab.pin,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, segment: .rate),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider)
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(on: .iPhone8, precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
}

// MARK: - LDR + Tests
extension LDR {
  static let testGroup = "org.kenzan8000.ladder-clientSnapshotTests"
}
