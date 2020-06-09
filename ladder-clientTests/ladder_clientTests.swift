@testable import ladder_client
@testable import SwiftyJSON
import XCTest

class ladder_clientTests: XCTestCase {

    var subscribeId: String? = nil
    
    override func setUpWithError() throws {
        super.setUp()
        subscribeId = nil
    }

    override func tearDownWithError() throws {
        subscribeId = nil
        super.tearDown()
    }
    

    // MARK: - http requests

    /// Tests Login
    func testLogin() {
        var responseError: Error?
        let promise = expectation(description: "Login Succeeded")
        LDRLoginOperationQueue.shared.start { (_, error) -> Void in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Feed Subs API
    func testRequestFeedSubs() {
        var responseError: Error?
        var responseJson: JSON?
        let promise = expectation(description: "Request Subs Succeeded")
        LDRFeedOperationQueue.shared.requestSubs { [unowned self] (json, error) -> Void in
            responseError = error
            responseJson = json
            if let json = json {
                let items = json.arrayValue
                for item in items {
                    self.subscribeId = item["subscribe_id"].stringValue
                    break
                }
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
        XCTAssertNil(responseJson)
    }

    /// Tests Requesting Feed Unread API
    func testRequestFeedUnread() {
        var responseError: Error?
        let promise = expectation(description: "Request Unread Succeeded")
        guard let sId = self.subscribeId else {
            XCTFail("You weren't able to get subscribeId from testRequestFeedSubs")
            return
        }
        LDRFeedOperationQueue.shared.requestUnread(subscribeId: sId) { (_, error) -> Void in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Feed Touch All API
    func testRequestFeedTouchAll() {
        var responseError: Error?
        let promise = expectation(description: "Request Touch All Succeeded")
        guard let sId = self.subscribeId else {
            XCTFail("You weren't able to get subscribeId from testRequestFeedSubs")
            return
        }
        LDRFeedOperationQueue.shared.requestTouchAll(subscribeId: sId) { (_, error) -> Void in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Pin Add  API
    func testRequestPinAdd() {
        var responseError: Error?
        let promise = expectation(description: "Request Pin Add Succeeded")
        guard let link = URL(string: "https://google.com") else {
            return
        }
        let title = "Google"
        LDRPinOperationQueue.shared.requestPinAdd(link: link, title: title) { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Pin Remove  API
    func testRequestPinRemove() {
        var responseError: Error?
        let promise = expectation(description: "Request Pin Remove Succeeded")
        guard let link = URL(string: "https://google.com") else {
            return
        }
        LDRPinOperationQueue.shared.requestPinRemove(link: link) { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Pin All  API
    func testRequestPinAll() {
        var responseError: Error?
        let promise = expectation(description: "Request Pin All Succeeded")
        LDRPinOperationQueue.shared.requestPinAll { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
}
