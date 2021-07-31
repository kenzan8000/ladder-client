import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+PinAddTests
class LDRRequestPinAddTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestPinAdd_whenSucceeding_LDRPinAddResponseIsSuccessShouldBeTrue() throws {
    var result: LDRPinAddResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRPinAddURLSessionSuccessMock()

    _ = sut
      .publisher(
        for: .pinAdd(
          apiKey: keychain.apiKey,
          ldrUrlString: keychain.ldrUrlString,
          title: "alextsui05 starred vercel/og-image",
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
  
  func testLDRRequestPinAdd_whenFailing_LDRPinAddResponseIsSuccessShouldBeFalse() throws {
    var result: LDRPinAddResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRPinAddURLSessionFailureMock()

    _ = sut
      .publisher(
        for: .pinAdd(
          apiKey: keychain.apiKey,
          ldrUrlString: keychain.ldrUrlString,
          title: "alextsui05 starred vercel/og-image",
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

// MARK: - LDRPinAddURLSessionSuccessMock
struct LDRPinAddURLSessionSuccessMock: LDRURLSession {
  func publisher<LDRPinAddResponse>(
    for request: LDRRequest<LDRPinAddResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRPinAddResponse, LDRError> where LDRPinAddResponse: Decodable {
      Future<LDRPinAddResponse, LDRError> { promise in
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = try! XCTUnwrap("{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8))
        let response = try! decoder.decode(LDRPinAddResponse.self, from: data)
        promise(.success(response))
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - LDRPinAddURLSessionFailureMock
struct LDRPinAddURLSessionFailureMock: LDRURLSession {
  func publisher<LDRPinAddResponse>(
    for request: LDRRequest<LDRPinAddResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRPinAddResponse, LDRError> where LDRPinAddResponse: Decodable {
    Future<LDRPinAddResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let data = try! XCTUnwrap("{\"ErrorCode\": 400, \"isSuccess\": false}".data(using: .utf8))
      let response = try! decoder.decode(LDRPinAddResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}
