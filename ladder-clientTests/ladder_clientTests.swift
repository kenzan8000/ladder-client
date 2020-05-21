import XCTest
@testable import ladder_client

class ladder_clientTests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testLogin() {
        let promise = expectation(description: "Login Succeeded")
        LDRSettingLoginOperationQueue.shared.start { (_, error) -> Void in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
}
