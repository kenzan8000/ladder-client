import SwiftUI
import XCTest
@testable import ladder_client

// MARK: - LDRPinViewTests
class LDRPinViewTests: XCTestCase {
  
  // MARK: property
  var storageProvider: LDRStorageProvider!
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    storageProvider = .fixture(source: Bundle(for: type(of: LDRPinViewTests())))
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
 
  func testLDRPinView_whenLoadingPinsFromCoreData_viewModelShouldHave6Pins() throws {
    let sut = LDRPinView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub())
    XCTAssertEqual(sut.pins.count, 6)
  }
  
  func testLDRPinView_whenLoadingPinsFromCoreData_viewModelShouldHave6PinTitles() throws {
    let sut = LDRPinView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub())
    XCTAssertEqual(
      sut.pins.map { $0.title },
      ["Using the MVI pattern in iOS.", "【Swift】Combineで一つのPublisherの出力結果を共有するメソッドやクラス の違い(share, multicast, Future) - Qiita", "This is The Entire Computer Science Curriculum in 1000 YouTube Videos", "Using self, weak, and unowned in Combine", "Dependency Injection and SwiftUI", "Working With Property Lists in Swift – Part 2"]
    )
  }
  
  func testLDRPinView_whenLoadingPinsFromCoreData_pinsShouldBeSortedByCreatedOn() throws {
    let sut = LDRPinView.ViewModel(storageProvider: storageProvider, keychain: LDRKeychainStub())
    let createdOns = sut.pins.map { $0.createdOn }
    XCTAssertTrue(zip(createdOns.dropLast(), createdOns.dropFirst()).allSatisfy(>=))
  }
}
