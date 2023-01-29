import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+TouchAllTests
class LDRRequestTouchAllTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
    LDRTestURLProtocol.requests = []
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestTouchAll_whenUsingLDRTestURLProtocol_requestShouldBeValid() throws {
    let subscribeId = 50
    let config = URLSessionConfiguration.default
    config.protocolClasses = [LDRTestURLProtocol.self]
    let keychain = LDRKeychainStub()
    keychain.ldrUrlString = "fastladder.com"
    let sut = LDRDefaultURLSession(keychain: keychain, urlSession: .init(configuration: config))

    sut.publisher(for: .touchAll(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, subscribeId: subscribeId, cookie: keychain.cookie))
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { _ in }
      )
      .cancel()
    usleep(1000)
    
    let request = try XCTUnwrap(LDRTestURLProtocol.requests.last)
    let url = try XCTUnwrap(request.url)
    XCTAssertEqual(url.absoluteString, "https://fastladder.com/api/touch_all")
    XCTAssertEqual(request.httpMethod, "POST")
    XCTAssertEqual(
      request.allHTTPHeaderFields,
      LDRRequestHeader.defaultHeader(url: url, body: ["ApiKey": "", "subscribe_id": "\(subscribeId)"].HTTPBodyValue(), cookie: nil)
    )
  }

  func testLDRRequestTouchAll_whenSucceeding_LDRTouchAllResponseIsSuccessShouldBeTrue() throws {
    let subscribeId = 50
    var result: LDRTouchAllResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRTouchAllURLSessionSuccessFake()

    _ = sut.publisher(for: .touchAll(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, subscribeId: subscribeId, cookie: keychain.cookie))
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
    let sut = LDRTouchAllURLSessionFailureFake()

    _ = sut.publisher(for: .touchAll(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, subscribeId: subscribeId, cookie: keychain.cookie))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.isSuccess == false)
  }
}

// MARK: - LDRTouchAllURLSessionSuccessFake
struct LDRTouchAllURLSessionSuccessFake: LDRURLSession {
  func publisher<LDRTouchAllResponse>(
    for request: LDRRequest<LDRTouchAllResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRTouchAllResponse, LDRError> where LDRTouchAllResponse: Decodable {
    Future<LDRTouchAllResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let data = try! XCTUnwrap("{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8))
      let response = try! decoder.decode(LDRTouchAllResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
  
  func data(from url: URL) async throws -> (Data, URLResponse) {
    (
      try XCTUnwrap("{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8)),
      URLResponse()
    )
  }
}

// MARK: - LDRTouchAllURLSessionFailureFake
struct LDRTouchAllURLSessionFailureFake: LDRURLSession {
  func publisher<LDRTouchAllResponse>(
    for request: LDRRequest<LDRTouchAllResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRTouchAllResponse, LDRError> where LDRTouchAllResponse: Decodable {
    Future<LDRTouchAllResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let data = try! XCTUnwrap("{\"ErrorCode\": 400, \"isSuccess\": false}".data(using: .utf8))
      let response = try! decoder.decode(LDRTouchAllResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
  
  func data(from url: URL) async throws -> (Data, URLResponse) {
    (
      try XCTUnwrap("{\"ErrorCode\": 0, \"isSuccess\": false}".data(using: .utf8)),
      URLResponse()
    )
  }
}
