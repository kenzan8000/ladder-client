import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+PinRemoveTests
class LDRRequestPinRemoveTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestPinRemove_whenSucceeding_LDRPinRemoveResponseIsSuccessShouldBeTrue() throws {
    var result: LDRPinRemoveResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRPinRemoveURLSessionSuccessFake()

    _ = sut
      .publisher(
        for: .pinRemove(
          apiKey: keychain.apiKey,
          ldrUrlString: keychain.ldrUrlString,
          link: URL(string: "https://github.com/vercel/og-image") ?? URL(fileURLWithPath: "")
        )
      )
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.isSuccess == true)
  }
  
  func testLDRRequestPinRemove_whenFailing_LDRPinRemoveResponseIsSuccessShouldBeFalse() throws {
    var result: LDRPinRemoveResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRPinRemoveURLSessionFailureFake()

    _ = sut
      .publisher(
        for: .pinRemove(
          apiKey: keychain.apiKey,
          ldrUrlString: keychain.ldrUrlString,
          link: URL(string: "https://github.com/vercel/og-image") ?? URL(fileURLWithPath: "")
        )
      )
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.isSuccess == false)
  }
}

// MARK: - LDRPinRemoveURLSessionSuccessFake
struct LDRPinRemoveURLSessionSuccessFake: LDRURLSession {
  func publisher<LDRPinRemoveResponse>(
    for request: LDRRequest<LDRPinRemoveResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRPinRemoveResponse, LDRError> where LDRPinRemoveResponse: Decodable {
    Future<LDRPinRemoveResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let data = try! XCTUnwrap("{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8))
      let response = try! decoder.decode(LDRPinRemoveResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - LDRPinRemoveURLSessionFailureFake
struct LDRPinRemoveURLSessionFailureFake: LDRURLSession {
  func publisher<LDRPinRemoveResponse>(
    for request: LDRRequest<LDRPinRemoveResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRPinRemoveResponse, LDRError> where LDRPinRemoveResponse: Decodable {
    Future<LDRPinRemoveResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let data = try! XCTUnwrap("{\"ErrorCode\": 400, \"isSuccess\": false}".data(using: .utf8))
      let response = try! decoder.decode(LDRPinRemoveResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}
