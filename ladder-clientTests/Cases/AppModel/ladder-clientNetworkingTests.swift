@testable import ladder_client
@testable import SwiftyJSON
import XCTest

class ladder_clientNetworkingTests: XCTestCase {

    var subscribeId: String? = nil
    
    override func setUpWithError() throws {
        super.setUp()
        // subscribeId = nil
    }

    override func tearDownWithError() throws {
        // subscribeId = nil
        super.tearDown()
    }
    

    // MARK: - http requests

    /// Tests Login
    func testLoginOperationQueue_whenInitialState_requestLogin() {
        var responseError: Error?
        let promise = expectation(description: "Login Succeeded")
        let sut = LDRLoginOperationQueue.shared
        sut.start { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Feed Subs API
    func testFeedOperationQueue_whenHavingSession_requestFeedSubs() {
        var responseError: Error?
        let promise = expectation(description: "Request Subs Succeeded")
        let sut = LDRFeedOperationQueue.shared
        sut.requestSubs { [unowned self] json, error in
            responseError = error
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
    }

    /// Tests Requesting Feed Unread API
    func testFeedOperationQueue_whenHavingSession_requestFeedUnread() {
        var responseError: Error?
        let promise = expectation(description: "Request Unread Succeeded")
        guard let sId = self.subscribeId else {
            XCTFail("You weren't able to get subscribeId from testRequestFeedSubs")
            return
        }
        let sut = LDRFeedOperationQueue.shared
        sut.requestUnread(subscribeId: sId) { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Feed Touch All API
    func testFeedOperationQueue_whenHavingSession_requestFeedTouchAll() {
        var responseError: Error?
        let promise = expectation(description: "Request Touch All Succeeded")
        guard let sId = self.subscribeId else {
            XCTFail("You weren't able to get subscribeId from testRequestFeedSubs")
            return
        }
        let sut = LDRFeedOperationQueue.shared
        sut.requestTouchAll(subscribeId: sId) { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Pin Add  API
    func testPinOperationQueue_whenHavingSession_requestPinAdd() {
        var responseError: Error?
        let promise = expectation(description: "Request Pin Add Succeeded")
        guard let link = URL(string: "https://google.com") else {
            return
        }
        let title = "Google"
        let sut = LDRPinOperationQueue.shared
        sut.requestPinAdd(link: link, title: title) { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Pin Remove  API
    func testPinOperationQueue_whenHavingSession_requestPinRemove() {
        var responseError: Error?
        let promise = expectation(description: "Request Pin Remove Succeeded")
        guard let link = URL(string: "https://google.com") else {
            return
        }
        let sut = LDRPinOperationQueue.shared
        sut.requestPinRemove(link: link) { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
    
    /// Tests Requesting Pin All  API
    func testPinOperationQueue_whenHavingSession_RequestPinAll() {
        var responseError: Error?
        let promise = expectation(description: "Request Pin All Succeeded")
        let sut = LDRPinOperationQueue.shared
        sut.requestPinAll { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
}
