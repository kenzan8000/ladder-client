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
 
    func testLDRPinRow_whenInitialState_titleShouldBeSame() throws {
        let sut = LDRPinRow.ViewModel(pin: LDRPinRowContent.fixture(title: "title"))
        XCTAssertEqual(sut.title, "title")
    }
}
