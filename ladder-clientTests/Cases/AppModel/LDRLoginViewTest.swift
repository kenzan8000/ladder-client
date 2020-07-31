@testable import ladder_client
@testable import ViewInspector
import XCTest

// MARK: - LDRLoginViewTest
class LDRLoginViewTest: XCTestCase {
    
    // MARK: - properties
    
    var sut: LDRLoginView?
    var loginViewModel: LDRLoginViewModel?
    
    // MARK: - initialization
    
    override func setUpWithError() throws {
        sut = LDRLoginView()
        loginViewModel = sut?.environmentObject(LDRLoginViewModel()) as? LDRLoginViewModel
        super.setUp()
    }

    // MARK: - destruction
    
    override func tearDownWithError() throws {
        sut = nil
        loginViewModel = nil
        super.tearDown()
    }

    // MARK: - tests
    
    /// Tests url domain text field
    func testLoginView_whenInitialState_urlDomainTextField() throws {
        let text = try sut?.urlDomainTextField.inspect().textField().text().string()
        print(text)
        XCTAssertNil(text)
    }
    
}
