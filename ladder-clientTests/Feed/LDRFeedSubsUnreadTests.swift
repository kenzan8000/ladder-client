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
    var error = storageProvider.saveSubsUnreads(
      by: response
    )
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
    
    let subsunreadByRate = storageProvider.fetchSubsUnreads(by: .rate)
    XCTAssertEqual(subsunreadByRate[0].rate, 5)
    XCTAssertEqual(subsunreadByRate[1].rate, 5)
    XCTAssertEqual(subsunreadByRate[2].rate, 3)
    XCTAssertEqual(subsunreadByRate[3].rate, 3)
    
    let subsunreadByFolders = storageProvider.fetchSubsUnreads(by: .folder)
    XCTAssertEqual(subsunreadByFolders[0].folder, "blog")
    XCTAssertEqual(subsunreadByFolders[1].folder, "blog")
    XCTAssertEqual(subsunreadByFolders[2].folder, "software engineering")
    XCTAssertEqual(subsunreadByFolders[3].folder, "software engineering")
  }
  
  // TODO
  // func testLDRFeedSubsUnread_whenInitialState_saveAndUpdate() throws {
  // }
}