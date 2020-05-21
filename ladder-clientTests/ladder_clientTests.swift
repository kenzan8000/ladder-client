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
    
    func testRequestSubs() {
        let promise = expectation(description: "Request Subs Succeeded")
        LDRFeedOperationQueue.shared.requestSubs { (_, error) -> Void in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testRequestUnread() {
        let promise = expectation(description: "Request Unread Succeeded")
        LDRFeedOperationQueue.shared.requestUnread(subscribeId: "1") { (_, error) -> Void in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testRequestTouchAll() {
        let promise = expectation(description: "Request Touch All Succeeded")
        LDRFeedOperationQueue.shared.requestTouchAll(subscribeId: "1") { (_, error) -> Void in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testRequestPinAdd() {
        let promise = expectation(description: "Request Pin Add Succeeded")
        guard let link = URL(string: "https://google.com") else {
            return
        }
        let title = "Google"
        LDRPinOperationQueue.shared.requestPinAdd(link: link, title: title) { _, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testRequestPinRemove() {
        let promise = expectation(description: "Request Pin Remove Succeeded")
        guard let link = URL(string: "https://google.com") else {
            return
        }
        LDRPinOperationQueue.shared.requestPinRemove(link: link) { _, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testRequestPinAll() {
        let promise = expectation(description: "Request Pin All Succeeded")
        LDRPinOperationQueue.shared.requestPinAll { _, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
}
