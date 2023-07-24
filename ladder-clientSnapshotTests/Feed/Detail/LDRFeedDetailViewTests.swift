/*
import SnapshotTesting
import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRFeedDetailViewTests
class LDRFeedDetailViewTests: XCTestCase {
    
    // MARK: property
    var storageProvider: LDRStorageProvider!

    // MARK: life cycle
    
    override func setUpWithError() throws {
        storageProvider = .fixture(source: Bundle(for: type(of: LDRFeedDetailViewTests())))
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    // MARK: test
    
    func testLDRFeedDetailView_whenInitialState_snapshotTesting() throws {
        [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
            let keychain = LDRKeychainStub()
            let subsunreads = storageProvider.fetchSubsUnreads(by: .rate)
            let sut = UIHostingController(
                rootView: LDRFeedDetailView(
                    viewModel: LDRFeedDetailView.ViewModel(
                        storageProvider: storageProvider,
                        keychain: keychain,
                        subsunread: subsunreads[0]
                    ),
                    webViewModel: LDRFeedDetailView.WebViewModel()
                )
            )
            sut.overrideUserInterfaceStyle = style
            assertSnapshot(
                matching: sut,
                as: .img(precision: 0.98),
                named: named + "-" + model.name,
                timeout: 10.0
            )
        }
    }

}
*/
