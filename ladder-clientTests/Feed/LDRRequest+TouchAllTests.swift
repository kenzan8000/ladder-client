import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+TouchAllTests
class LDRRequestTouchAllTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestTouchAll_whenSucceeding_LDRTouchAllResponseWithIsSuccessIsTrue() throws {
    let subscribeId = 50
    var result: LDRTouchAllResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeSuccessPublisher(for: .touchAll(subscribeId: subscribeId))

    _ = sut
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.isSuccess == true)
  }
  
  func testLDRRequestTouchAll_whenFailing_LDRTouchAllResponseWithIsSuccessIsFalse() throws {
    let subscribeId = 50
    var result: LDRTouchAllResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeFailurePublisher(for: .touchAll(subscribeId: subscribeId))

    _ = sut
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.isSuccess == false)
  }
}

// MARK: - URLSession + Fake
extension URLSession {
  func fakeSuccessPublisher(for request: LDRRequest<LDRTouchAllResponse>) -> AnyPublisher<LDRTouchAllResponse, LDRError> {
    Future<LDRTouchAllResponse, LDRError> { promise in
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let data = "{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8),
         let response = try? decoder.decode(LDRTouchAllResponse.self, from: data) {
        promise(.success(response))
      } else {
        promise(.failure(LDRError.others("Failed to load response string.")))
      }
    }
    .eraseToAnyPublisher()
  }
  
  func fakeFailurePublisher(for request: LDRRequest<LDRTouchAllResponse>) -> AnyPublisher<LDRTouchAllResponse, LDRError> {
    Future<LDRTouchAllResponse, LDRError> { promise in
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let data = "{\"ErrorCode\": 400, \"isSuccess\": false}".data(using: .utf8),
         let response = try? decoder.decode(LDRTouchAllResponse.self, from: data) {
        promise(.success(response))
      } else {
        promise(.failure(LDRError.others("Failed to load response string.")))
      }
    }
    .eraseToAnyPublisher()
  }
}
