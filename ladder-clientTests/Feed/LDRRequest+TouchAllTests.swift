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
  
  func testLDRRequestTouchAll_whenSucceeding_LDRTouchAllResponseIsSuccessShouldBeTrue() throws {
    let subscribeId = 50
    var result: LDRTouchAllResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRTouchAllURLSessionSuccessMock()

    _ = sut.publisher(for: .touchAll(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, subscribeId: subscribeId))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.isSuccess == true)
  }
  
  func testLDRRequestTouchAll_whenFailing_LDRTouchAllResponseIsSuccessShouldBeFalse() throws {
    let subscribeId = 50
    var result: LDRTouchAllResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRTouchAllURLSessionFailureMock()

    _ = sut.publisher(for: .touchAll(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, subscribeId: subscribeId))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.isSuccess == false)
  }
}

// MARK: - LDRTouchAllURLSessionSuccessMock
struct LDRTouchAllURLSessionSuccessMock: LDRURLSession {
  func publisher<LDRTouchAllResponse>(
    for request: LDRRequest<LDRTouchAllResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRTouchAllResponse, LDRError> where LDRTouchAllResponse: Decodable {
    Future<LDRTouchAllResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let data = "{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8)!
      let response = try! decoder.decode(LDRTouchAllResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - LDRTouchAllURLSessionFailureMock
struct LDRTouchAllURLSessionFailureMock: LDRURLSession {
  func publisher<LDRTouchAllResponse>(
    for request: LDRRequest<LDRTouchAllResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRTouchAllResponse, LDRError> where LDRTouchAllResponse: Decodable {
    Future<LDRTouchAllResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let data = "{\"ErrorCode\": 400, \"isSuccess\": false}".data(using: .utf8)!
      let response = try! decoder.decode(LDRTouchAllResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}
