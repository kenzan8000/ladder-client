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
  
  func testLDRRequestPinAll_whenValidJsonResponse_LDRPinAllResponseIsValid() throws {
    var result: LDRPinAllResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeValidPublisher(for: .pinAll())

    _ = sut
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.count == 5)
  }
}

// MARK: - URLSession + Fake
extension URLSession {
  func fakeValidPublisher(for request: LDRRequest<LDRPinAllResponse>) -> AnyPublisher<LDRPinAllResponse, LDRError> {
    Future<LDRPinAllResponse, LDRError> { promise in
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let url = Bundle(for: type(of: LDRRequestPinAllTests())).url(forResource: "pinAll", withExtension: "json")!
      let data = try! Data(contentsOf: url, options: .uncached)
      let response = try! decoder.decode(LDRPinAllResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}
