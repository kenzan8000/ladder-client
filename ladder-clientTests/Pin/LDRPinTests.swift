import XCTest
@testable import ladder_client

// MARK: - LDRPinTests
class LDRPinTests: XCTestCase {

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
 
  func testLDRUnread_whenInitialState_saveAndDelete() throws {
    // initial state
    XCTAssertFalse(storageProvider.existPin(link: "https://kenzan8000.org"))
    XCTAssertEqual(storageProvider.countPins(), 0)
    XCTAssertEqual(storageProvider.fetchPins(), [])
    
    // save a record by title and link
    storageProvider.savePin(title: "Kenzan Hase", link: "https://kenzan8000.org")
    XCTAssertTrue(storageProvider.existPin(link: "https://kenzan8000.org"))
    XCTAssertEqual(storageProvider.countPins(), 1)
    XCTAssertEqual(storageProvider.fetchPins()[0].link, "https://kenzan8000.org")
    
    // save a record by response
    var error = storageProvider.savePins(
      by: [
        LDRPinResponse(createdOn: 0, link: "https://kenzan8000.org/es", title: "Articlos de Kenzan"),
        LDRPinResponse(createdOn: 0, link: "https://kenzan8000.org/ja", title: "Kenzan HaseのBlog"),
      ]
    )
    XCTAssertNil(error)
    XCTAssertTrue(storageProvider.existPin(link: "https://kenzan8000.org/es"))
    XCTAssertEqual(storageProvider.countPins(), 3)
    let pins = storageProvider.fetchPins()
    pins
      .forEach {
        XCTAssertTrue(["https://kenzan8000.org",  "https://kenzan8000.org/es", "https://kenzan8000.org/ja"].contains($0.link))
      }
    
    // delete a record
    error = storageProvider.deletePin(pins[0])
    XCTAssertNil(error)
    XCTAssertEqual(storageProvider.countPins(), 2)
    
    // delete all records
    error = storageProvider.deletePins()
    XCTAssertNil(error)
    XCTAssertFalse(storageProvider.existPin(link: "https://kenzan8000.org"))
    XCTAssertEqual(storageProvider.countPins(), 0)
    XCTAssertEqual(storageProvider.fetchPins(), [])
  }

}
