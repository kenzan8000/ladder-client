/*
import KeychainAccess
import SnapshotTesting
import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRLoginViewTests
class LDRLoginViewTests: XCTestCase {

    // MARK: life cycle
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    // MARK: test
    
    func testLDRLoginView_whenInitialState_snapshotTesting() throws {
        Keychain.test[LDRKeychain.ldrUrlString] = ""
        let sut = UIHostingController(
            rootView: LDRLoginView().environmentObject(LDRLoginViewModel())
        )
        
        [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
            sut.overrideUserInterfaceStyle = style
            assertSnapshot(
                matching: sut,
                as: .img(precision: 0.98),
                named: named + "-" + model.name
            )
        }
    }
    
    func testLDRLoginView_whenInitialStateWithDomain_snapshotTesting() throws {
        Keychain.test[LDRKeychain.ldrUrlString] = "kenzan8000.org"
        let sut = UIHostingController(
            rootView: LDRLoginView().environmentObject(LDRLoginViewModel())
        )
        
        [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
            sut.overrideUserInterfaceStyle = style
            assertSnapshot(
                matching: sut,
                as: .img(precision: 0.98),
                named: named + "-" + model.name
            )
        }
    }
    
    func testLDRLoginView_whenFormIsFilled_snapshotTesting() throws {
        Keychain.test[LDRKeychain.ldrUrlString] = "kenzan8000.org"
        let viewModel = LDRLoginViewModel()
        let sut = UIHostingController(
            rootView: LDRLoginView().environmentObject(viewModel)
        )
        viewModel.username = "username"
        viewModel.password = "password"
        viewModel.loginDisabled = false

        [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
            sut.overrideUserInterfaceStyle = style
            assertSnapshot(
                matching: sut,
                as: .img(precision: 0.98),
                named: named + "-" + model.name
            )
        }
    }
    
    func testLDRLoginView_whenLogingIn_snapshotTesting() throws {
        Keychain.test[LDRKeychain.ldrUrlString] = "kenzan8000.org"
        let viewModel = LDRLoginViewModel()
        let sut = UIHostingController(
            rootView: LDRLoginView().environmentObject(viewModel)
        )
        viewModel.username = "username"
        viewModel.password = "password"
        viewModel.loginDisabled = false
        viewModel.isLogingIn = true

        [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
            sut.overrideUserInterfaceStyle = style
            assertSnapshot(
                matching: sut,
                as: .img(precision: 0.98),
                named: named + "-" + model.name
            )
        }
    }
}
*/
