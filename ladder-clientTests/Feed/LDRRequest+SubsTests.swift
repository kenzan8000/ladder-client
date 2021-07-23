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
  
  func testLDRRequestSubs_whenValidJsonResponse_LDRSubsResponseShouldBeValid() throws {
    var result: LDRSubsResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRSubsURLSessionMock()

    _ = sut.publisher(for: .subs(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.count == 6)
  }
}

// MARK: - LDRSubsURLSessionMock
struct LDRSubsURLSessionMock: LDRURLSession  {
  func publisher<LDRSubsResponse>(
    for request: LDRRequest<LDRSubsResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRSubsResponse, LDRError> where LDRSubsResponse: Decodable {
    Future<LDRSubsResponse, LDRError> { promise in
      // let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let url = Bundle(for: type(of: LDRRequestSubsTests())).url(forResource: "subs", withExtension: "json")!
      let data = try! Data(contentsOf: url, options: .uncached)
      let response = try! decoder.decode(LDRSubsResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}
