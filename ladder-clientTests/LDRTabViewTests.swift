import SnapshotTesting
import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRTabViewTests+SubsTests
class LDRTabViewTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testMapZoomButton_whenSelectedTabIsFeed_snapshotTesting() throws {
    let storageProvider = LDRStorageProvider(name: .ldrCoreData, group: "org.kenzan8000.ladder-client.test")
    let sut = UIHostingController(
      rootView: LDRTabView(
        selected: LDRTabView.Tab.feed,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider)
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image,
        named: named
      )
    }
  }
  
  func testMapZoomButton_whenSelectedTabIsPin_snapshotTesting() throws {
    let storageProvider = LDRStorageProvider(name: .ldrCoreData, group: "org.kenzan8000.ladder-client.test")
    let sut = UIHostingController(
      rootView: LDRTabView(
        selected: LDRTabView.Tab.pin,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider)
      )
    )
    
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image,
        named: named
      )
    }
  }
}
