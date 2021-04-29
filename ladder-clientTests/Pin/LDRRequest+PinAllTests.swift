import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+PinAllTests
class LDRRequestPinAllTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestPinAll_whenValidJsonResponse_LDRPinAllResponseShouldBeValid() throws {
    var result: LDRPinAllResponse? = nil
    let exp = expectation(description: #function)
    let sut = LDRPinAllURLSessionMock()

    _ = sut.publisher(for: .pinAll())
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.count == 5)
  }
}

// MARK: - LDRPinAllURLSessionMock
struct LDRPinAllURLSessionMock: LDRURLSession {
  func publisher<LDRPinAllResponse>(
    for request: LDRRequest<LDRPinAllResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRPinAllResponse, LDRError> where LDRPinAllResponse: Decodable {
    Future<LDRPinAllResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let url = Bundle(for: type(of: LDRRequestPinAllTests())).url(forResource: "pinAll", withExtension: "json")!
      let data = try! Data(contentsOf: url, options: .uncached)
      let response = try! decoder.decode(LDRPinAllResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}
