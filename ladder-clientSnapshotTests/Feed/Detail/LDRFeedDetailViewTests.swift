import SnapshotTesting
import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRFeedDetailViewTests
class LDRFeedDetailViewTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRFeedDetailView_whenInitialState_snapshotTesting() throws {
    let storageProvider = LDRStorageProvider(source: Bundle(for: type(of: LDRFeedDetailViewTests())), name: LDR.coreData, group: LDR.testGroup)
    let keychain = LDRKeychainMock()
    let subsunreads = storageProvider.fetchSubsUnreads(by: .rate)
    let sut = UIHostingController(
      rootView: LDRFeedDetailView(
        feedDetailViewModel: LDRFeedDetailViewModel(
          storageProvider: storageProvider,
          keychain: keychain,
          subsunread: subsunreads[0]
        ),
        feedDetailWebViewModel: LDRFeedDetailWebViewModel()
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
