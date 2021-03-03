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
  
  func testLDRRequestPinAdd_whenSucceeding_LDRPinAddResponseWithIsSuccessIsTrue() throws {
    var result: LDRPinAddResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeSuccessPublisher(
      for: .pinAdd(
        link: URL(string: "https://github.com/vercel/og-image") ?? URL(fileURLWithPath: ""),
        title: "alextsui05 starred vercel/og-image"
      )
    )

    _ = sut
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.isSuccess == true)
  }
  
  func testLDRRequestPinAdd_whenFailing_LDRPinAddResponseWithIsSuccessIsFalse() throws {
    var result: LDRPinAddResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeFailurePublisher(
      for: .pinAdd(
        link: URL(string: "https://github.com/vercel/og-image") ?? URL(fileURLWithPath: ""),
        title: "alextsui05 starred vercel/og-image"
      )
    )

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
  func fakeSuccessPublisher(for request: LDRRequest<LDRPinAddResponse>) -> AnyPublisher<LDRPinAddResponse, Swift.Error> {
    Future<LDRPinAddResponse, Swift.Error> { promise in
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let data = "{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8),
         let response = try? decoder.decode(LDRPinAddResponse.self, from: data) {
        promise(.success(response))
      } else {
        promise(.failure(LDRError.failed("Failed to load response string.")))
      }
    }
    .eraseToAnyPublisher()
  }
  
  func fakeFailurePublisher(for request: LDRRequest<LDRPinAddResponse>) -> AnyPublisher<LDRPinAddResponse, Swift.Error> {
    Future<LDRPinAddResponse, Swift.Error> { promise in
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let data = "{\"ErrorCode\": 400, \"isSuccess\": false}".data(using: .utf8),
         let response = try? decoder.decode(LDRPinAddResponse.self, from: data) {
        promise(.success(response))
      } else {
        promise(.failure(LDRError.failed("Failed to load response string.")))
      }
    }
    .eraseToAnyPublisher()
  }
}
