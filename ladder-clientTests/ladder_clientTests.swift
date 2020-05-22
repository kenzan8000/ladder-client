@testable import ladder_client
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
        let promise = expectation(description: "Login Succeeded")
        LDRSettingLoginOperationQueue.shared.start { (_, error) -> Void in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
    /// Tests Requesting Feed Subs API
    func testRequestFeedSubs() {
        let promise = expectation(description: "Request Subs Succeeded")
        LDRFeedOperationQueue.shared.requestSubs { [unowned self] (json, error) -> Void in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                guard let json = json else {
                    XCTFail("You didn't receive JSON response.")
                    return
                }
                let items = json.arrayValue
                for item in items {
                    self.subscribeId = item["subscribe_id"].stringValue
                    break
                }
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 60)
    }

    /// Tests Requesting Feed Unread API
    func testRequestFeedUnread() {
        let promise = expectation(description: "Request Unread Succeeded")
        guard let sId = self.subscribeId else {
            XCTFail("You weren't able to get subscribeId from testRequestFeedSubs")
            return
        }
        LDRFeedOperationQueue.shared.requestUnread(subscribeId: sId) { (_, error) -> Void in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
    /// Tests Requesting Feed Touch All API
    func testRequestFeedTouchAll() {
        let promise = expectation(description: "Request Touch All Succeeded")
        LDRFeedOperationQueue.shared.requestTouchAll(subscribeId: "1") { (_, error) -> Void in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
    /// Tests Requesting Pin Add  API
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
        wait(for: [promise], timeout: 10)
    }
    
    /// Tests Requesting Pin Remove  API
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
        wait(for: [promise], timeout: 10)
    }
    
    /// Tests Requesting Pin All  API
    func testRequestPinAll() {
        let promise = expectation(description: "Request Pin All Succeeded")
        LDRPinOperationQueue.shared.requestPinAll { _, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 10)
    }
}
