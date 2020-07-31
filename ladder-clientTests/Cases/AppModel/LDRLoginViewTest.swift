@testable import ladder_client
import XCTest

// MARK: - LDRLoginViewTest
class LDRLoginViewTest: XCTestCase {
    
    // MARK: - properties
    
    var sut: LDRLoginView?
    
    // MARK: - initialization
    
    override func setUpWithError() throws {
        sut = LDRLoginView()
        super.setUp()
    }

    // MARK: - destruction
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    // MARK: - tests
    /*
    /// Tests url domain text field
    func testLoginView_whenInitialState_urlDomainTextField() {
    }
    */
}
