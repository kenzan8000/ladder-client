import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+SubsTests
class LDRRequestSubsTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestSubs_whenValidJsonResponse_LDRSubsResponseIsValid() throws {
    var result: LDRSubsResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeValidPublisher(for: .subs())

    _ = sut
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.count == 6)
  }
}

// MARK: - URLSession + Fake
extension URLSession {
  func fakeValidPublisher(for request: LDRRequest<LDRSubsResponse>) -> AnyPublisher<LDRSubsResponse, LDRError> {
    Future<LDRSubsResponse, LDRError> { promise in
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let url = Bundle(for: type(of: LDRRequestSubsTests())).url(forResource: "subs", withExtension: "json"),
         let data = try? Data(contentsOf: url, options: .uncached),
         let response = try? decoder.decode(LDRSubsResponse.self, from: data) {
        promise(.success(response))
      } else {
        promise(.failure(LDRError.others("Failed to load local json file.")))
      }
    }
    .eraseToAnyPublisher()
  }
}
