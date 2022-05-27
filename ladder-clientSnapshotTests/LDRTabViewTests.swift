import SnapshotTesting
import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRTabViewTests
class LDRTabViewTests: XCTestCase {

  // MARK: property
  var storageProvider: LDRStorageProvider!
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    storageProvider = .fixture(source: Bundle(for: type(of: LDRTabViewTests())))
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRTabView_whenSelectedTabIsFeedAndSegmentIsRate_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let keychain = LDRKeychainStub()
      let sut = UIHostingController(
        rootView: LDRTabView(
          keychain: keychain,
          selected: LDRTabView.Tab.feed,
          feedViewModel: LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate),
          pinViewModel: LDRPinView.ViewModel(storageProvider: storageProvider, keychain: keychain)
        )
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRTabView_whenSelectedTabIsFeedAndSegmentIsFolder_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let keychain = LDRKeychainStub()
      let sut = UIHostingController(
        rootView: LDRTabView(
          keychain: keychain,
          selected: LDRTabView.Tab.feed,
          feedViewModel: LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: keychain, segment: .folder),
          pinViewModel: LDRPinView.ViewModel(storageProvider: storageProvider, keychain: keychain)
        )
      )
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testLDRTabView_whenSelectedTabIsPin_snapshotTesting() throws {
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      let keychain = LDRKeychainStub()
      let sut = UIHostingController(
        rootView: LDRTabView(
          keychain: keychain,
          selected: LDRTabView.Tab.pin,
          feedViewModel: LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate),
          pinViewModel: LDRPinView.ViewModel(storageProvider: storageProvider, keychain: keychain)
        )
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
