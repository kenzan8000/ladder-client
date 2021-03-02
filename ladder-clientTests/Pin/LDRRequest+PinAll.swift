import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+PinAll
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
    XCTAssertNotNil(result?.count == 4)
  }
}

// MARK: - URLSession + Fake
extension URLSession {
  func fakeValidPublisher(for request: LDRRequest<LDRPinAllResponse>) -> AnyPublisher<LDRPinAllResponse, Swift.Error> {
    Future<LDRPinAllResponse, Swift.Error> { promise in
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let url = Bundle(for: type(of: LDRRequestLoginTests())).url(forResource: "pinAll", withExtension: "json"),
         let data = try? Data(contentsOf: url, options: .uncached),
         let response = try? decoder.decode(LDRPinAllResponse.self, from: data) {
        promise(.success(response))
      } else {
        promise(.failure(LDRError.failed("Failed to load local json file.")))
      }
    }
    .eraseToAnyPublisher()
  }
}
