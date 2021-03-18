import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+UnreadTests
class LDRRequestUnreadTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestUnread_whenValidJsonResponse_LDRUnreadResponseIsValid() throws {
    let subscribeId = 50
    var result: LDRUnreadResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeValidPublisher(for: .unread(subscribeId: subscribeId))

    _ = sut
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.subscribeId == subscribeId)
  }
}

// MARK: - URLSession + Fake
extension URLSession {
  func fakeValidPublisher(for request: LDRRequest<LDRUnreadResponse>) -> AnyPublisher<LDRUnreadResponse, LDRError> {
    Future<LDRUnreadResponse, LDRError> { promise in
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let url = Bundle(for: type(of: LDRRequestUnreadTests())).url(forResource: "unread", withExtension: "json")!
      let data = try! Data(contentsOf: url, options: .uncached)
      let response = try! decoder.decode(LDRUnreadResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}
