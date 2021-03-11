import XCTest
@testable import ladder_client

// MARK: - LDRFeedSubsUnreadTest
class LDRFeedSubsUnreadTest: XCTestCase {

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
 
  func testLDRFeedSubsUnread_whenInitialState_saveAndDelete() throws {
    let response = [LDRSubResponse(rate: 5, folder: "blog", title: "Kenzan Hase", subscribeId: 1, link: "https://kenzan8000.org", icon: "", unreadCount: 3, subscribersCount: 1, feedlink: "https://kenzan8000.org/feed")]
    var error = storageProvider.saveSubsUnreads(by: response)
    var count = storageProvider.countSubsUnreads()
    XCTAssertNil(error)
    XCTAssertEqual(count, response.count)
    
    error = storageProvider.deleteSubsUnreads()
    count = storageProvider.countSubsUnreads()
    XCTAssertNil(error)
    XCTAssertEqual(count, 0)
  }
  
  func testLDRFeedSubsUnread_whenInitialState_saveAndFetch() throws {
    let response = [
      LDRSubResponse(rate: 5, folder: "blog", title: "Kenzan Hase", subscribeId: 1, link: "https://kenzan8000.org", icon: "", unreadCount: 3, subscribersCount: 1, feedlink: "https://kenzan8000.org/feed"),
      LDRSubResponse(rate: 5, folder: "blog", title: "Kenzan Hase", subscribeId: 2, link: "https://kenzan8000.org/es", icon: "", unreadCount: 3, subscribersCount: 1, feedlink: "https://kenzan8000.org/es/feed"),
      LDRSubResponse(rate: 3, folder: "software engineering", title: "Kenzan Hase", subscribeId: 3, link: "https://kenzan8000.org/ja", icon: "", unreadCount: 3, subscribersCount: 1, feedlink: "https://kenzan8000.org/ja/feed"),
      LDRSubResponse(rate: 3, folder: "software engineering", title: "Kenzan Hase", subscribeId: 4, link: "https://kenzan8000.org/zh", icon: "", unreadCount: 3, subscribersCount: 1, feedlink: "https://kenzan8000.org/zh/feed")
    ]
    let error = storageProvider.saveSubsUnreads(by: response)
    let count = storageProvider.countSubsUnreads()
    XCTAssertNil(error)
    XCTAssertEqual(count, response.count)
    
    let subsunreadsByRate = storageProvider.fetchSubsUnreads(by: .rate)
    XCTAssertEqual(subsunreadsByRate[0].rate, 5)
    XCTAssertEqual(subsunreadsByRate[1].rate, 5)
    XCTAssertEqual(subsunreadsByRate[2].rate, 3)
    XCTAssertEqual(subsunreadsByRate[3].rate, 3)
    
    let subsunreadsByFolders = storageProvider.fetchSubsUnreads(by: .folder)
    XCTAssertEqual(subsunreadsByFolders[0].folder, "blog")
    XCTAssertEqual(subsunreadsByFolders[1].folder, "blog")
    XCTAssertEqual(subsunreadsByFolders[2].folder, "software engineering")
    XCTAssertEqual(subsunreadsByFolders[3].folder, "software engineering")
  }
  
  func testLDRFeedSubsUnread_whenInitialState_saveAndUpdate() throws {
    let response = [LDRSubResponse(rate: 5, folder: "blog", title: "Kenzan Hase", subscribeId: 1, link: "https://kenzan8000.org", icon: "", unreadCount: 3, subscribersCount: 1, feedlink: "https://kenzan8000.org/feed")]
    let error = storageProvider.saveSubsUnreads(by: response)
    XCTAssertNil(error)

    let subsunreads = storageProvider.fetchSubsUnreads(by: .rate)
    XCTAssertEqual(subsunreads[0].state, LDRFeedSubsUnreadState.unloaded)
    
    storageProvider.updateSubsUnread(subsunreads[0], state: .unread)
    XCTAssertEqual(subsunreads[0].state, LDRFeedSubsUnreadState.unread)
    
    storageProvider.updateSubsUnread(subsunreads[0], state: .read)
    XCTAssertEqual(subsunreads[0].state, LDRFeedSubsUnreadState.read)
  }
}
