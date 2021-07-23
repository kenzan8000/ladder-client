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
    let keychain = LDRKeychainStub()
    let sut = UIHostingController(
      rootView: LDRTabView(
        keychain: keychain,
        selected: LDRTabView.Tab.feed,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider, keychain: keychain)
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
  
  func testLDRTabView_whenSelectedTabIsFeedAndSegmentIsFolder_snapshotTesting() throws {
    let storageProvider = LDRStorageProvider(source: Bundle(for: type(of: LDRTabViewTests())), name: LDR.coreData, group: LDR.testGroup)
    let keychain = LDRKeychainStub()
    let sut = UIHostingController(
      rootView: LDRTabView(
        keychain: keychain,
        selected: LDRTabView.Tab.feed,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, keychain: keychain, segment: .folder),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider, keychain: keychain)
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
  
  func testLDRTabView_whenSelectedTabIsPin_snapshotTesting() throws {
    let storageProvider = LDRStorageProvider(source: Bundle(for: type(of: LDRTabViewTests())), name: LDR.coreData, group: LDR.testGroup)
    let keychain = LDRKeychainStub()
    let sut = UIHostingController(
      rootView: LDRTabView(
        keychain: keychain,
        selected: LDRTabView.Tab.pin,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider, keychain: keychain)
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
