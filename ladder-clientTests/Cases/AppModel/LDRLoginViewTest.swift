@testable import ladder_client
@testable import ViewInspector
import XCTest

// extension Inspection: InspectionEmissary where V: Inspectable { }
extension LDRLoginView: Inspectable { }

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
    
    /// Tests if URL Domain TextField text should equal to LoginViewModel url domain.
    func testLoginView_whenInitialState_urlDomainTextFieldTextShouldEqualToLoginViewModelUrlDomain() throws {
        let viewModel = LDRLoginViewModel()
        let urlDomain = viewModel.urlDomain
        var text: String? = nil
        let promise = expectation(description: "URL Domain TextField text should equal to LoginViewModel url domain.")
        sut?.on(\.didAppear) { view in
            text = try view.actualView()
                .urlDomainTextField.inspect()
                .textField().text().string()
            promise.fulfill()
        }
        ViewHosting.host(view: sut.environmentObject(viewModel))
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(text, urlDomain)
        /*
        guard let sut = sut else {
            XCTAssertNotNil(nil)
            return
        }
        let promise = sut.inspection.inspect(after: 1) { view in
            urlDomain = try view.actualView().loginViewModel.urlDomain
            XCTAssertEqual(text, urlDomain)
        }
        ViewHosting.host(view: sut.environmentObject(LDRLoginViewModel()))
        wait(for: [promise], timeout: 1)
        */
    }
    
}
