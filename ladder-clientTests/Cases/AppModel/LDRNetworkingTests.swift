@testable import ladder_client
@testable import SwiftyJSON
import XCTest

// MARK: - LDRNetworkingTests
class LDRNetworkingTests: XCTestCase {
    
    // MARK: - properties
    
    let subscribeId = "LDRNetworkingTests.subscribeId"
    var userDefaults: UserDefaults? = nil
    
    // MARK: - initialization
    
    override func setUpWithError() throws {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "LDRNetworkingTests")
    }

    // MARK: - destruction
    
    override func tearDownWithError() throws {
        userDefaults = nil
        super.tearDown()
    }

    // MARK: - tests

    /// Tests Login
    func testLoginOperationQueue_whenInitialState_requestLogin() {
        var responseError: Error?
        let promise = expectation(description: "Login Succeeded")
        let sut = LDRLoginOperationQueue()
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
        let sut = LDRFeedOperationQueue()
        sut.requestSubs { [unowned self] json, error in
            responseError = error
            if let json = json {
                let items = json.arrayValue
                for item in items {
                    self.userDefaults?.setValue(
                        item["subscribe_id"].stringValue,
                        forKey: self.subscribeId
                    )
                    self.userDefaults?.synchronize()
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

        guard let sId = userDefaults?.string(forKey: subscribeId) else {
            XCTFail("You weren't able to get subscribeId from testRequestFeedSubs")
            return
        }
        let sut = LDRFeedOperationQueue()
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
        guard let sId = userDefaults?.string(forKey: subscribeId) else {
            XCTFail("You weren't able to get subscribeId from testRequestFeedSubs")
            return
        }
        let sut = LDRFeedOperationQueue()
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
        let sut = LDRPinOperationQueue()
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
        let sut = LDRPinOperationQueue()
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
        let sut = LDRPinOperationQueue()
        sut.requestPinAll { _, error in
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(responseError)
    }
}
