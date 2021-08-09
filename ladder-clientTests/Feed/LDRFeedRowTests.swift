import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRFeedRowTests
class LDRFeedRowTests: XCTestCase {
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
 
  func testLDRFeedRow_whenInitialState_shouldEqualToSameTitleAndUnreadCount() throws {
    let sut = LDRFeedRow.ViewModel(subsunread: LDRFeedRowContent.fixture(title: "はてなブックマーク - お気に入り", unreadCount: 187, state: .unread))
    XCTAssertEqual(sut.title, "はてなブックマーク - お気に入り")
    XCTAssertEqual(sut.unreadCount, "187")
  }
  
  func testLDRFeedRow_whenStateIsUnloadedAndUnreadCountIs187_colorShouldBeGrayAndUnreadCountShouldBe187() throws {
    let sut = LDRFeedRow.ViewModel(subsunread: LDRFeedRowContent.fixture(unreadCount: 187, state: .unloaded))
    XCTAssertEqual(sut.color, Color.gray)
    XCTAssertEqual(sut.unreadCount, "187")
  }
  
  func testLDRFeedRow_whenStateIsUnreadAndUnreadCountIs187_colorShouldBeBlueAndUnreadCountShouldBe187() throws {
    let sut = LDRFeedRow.ViewModel(subsunread: LDRFeedRowContent.fixture(unreadCount: 187, state: .unread))
    XCTAssertEqual(sut.color, Color.blue)
    XCTAssertEqual(sut.unreadCount, "187")
  }
  
  func testLDRFeedRow_whenStateIsReadAndUnreadCountIs187_colorShouldBeGrayAndUnreadCountShouldBeEmpty() throws {
    let sut = LDRFeedRow.ViewModel(subsunread: LDRFeedRowContent.fixture(unreadCount: 187, state: .read))
    XCTAssertEqual(sut.color, Color.gray)
    XCTAssertEqual(sut.unreadCount, "")
  }
}
