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
  
  func testLDRRequestUnread_whenValidJsonResponse_LDRUnreadResponseShouldBeValid() throws {
    let subscribeId = 50
    var result: LDRUnreadResponse? = nil
    let exp = expectation(description: #function)
    let sut = LDRUnreadURLSessionMock()

    _ = sut.publisher(for: .unread(subscribeId: subscribeId))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.subscribeId == subscribeId)
  }
}

// MARK: - LDRUnreadURLSessionMock
struct LDRUnreadURLSessionMock: LDRURLSession {
  func publisher<LDRUnreadResponse>(
    for request: LDRRequest<LDRUnreadResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRUnreadResponse, LDRError> where LDRUnreadResponse: Decodable {
    Future<LDRUnreadResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let url = Bundle(for: type(of: LDRRequestUnreadTests())).url(forResource: "unread", withExtension: "json")!
      let data = try! Data(contentsOf: url, options: .uncached)
      let response = try! decoder.decode(LDRUnreadResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}
