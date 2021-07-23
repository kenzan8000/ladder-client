import XCTest
@testable import ladder_client

// MARK: - LDRUnreadTests
class LDRUnreadTests: XCTestCase {

  // MARK: property
  var storageProvider = LDRStorageProvider(name: LDR.coreData, group: LDR.group, storeType: .inMemory)
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    storageProvider = LDRStorageProvider(name: LDR.coreData, group: LDR.group, storeType: .inMemory)
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
 
  func testLDRUnread_whenInitialState_shouldBeAbleToSave() throws {
    // LDRFeedSubsUnread (parent entity)
    let subsResponse = [LDRSubResponse(rate: 5, folder: "blog", title: "Kenzan Hase", subscribeId: 1, link: "https://kenzan8000.org", icon: "", unreadCount: 3, subscribersCount: 1, feedlink: "https://kenzan8000.org/feed")]
    let error = storageProvider.saveSubsUnreads(by: subsResponse)
    let subsunreads = storageProvider.fetchSubsUnreads(by: .rate)
    XCTAssertNil(error)
    XCTAssertTrue(subsunreads[0].unreads.count == 0)

    // save LDRFeedUnread (child entity)
    var unreadResponse: LDRUnreadResponse? = nil
    let keychain = LDRKeychainStub()
    let exp = expectation(description: #function)
    _ = LDRUnreadURLSessionMock().publisher(for: .unread(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, subscribeId: subsunreads[0].subscribeId))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { unreadResponse = $0 }
      )
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(unreadResponse)
    storageProvider.saveUnread(by: unreadResponse!, subsUnread: subsunreads[0])
    XCTAssertTrue(subsunreads[0].unreads.count > 0)
  }

}
