import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+PinAddTests
class LDRRequestPinAddTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
    LDRTestURLProtocol.requests = []
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestPinAdd_whenUsingLDRTestURLProtocol_requestShouldBeValid() throws {
    let config = URLSessionConfiguration.default
    config.protocolClasses = [LDRTestURLProtocol.self]
    let keychain = LDRKeychainStub()
    keychain.ldrUrlString = "fastladder.com"
    let sut = LDRDefaultURLSession(keychain: keychain, urlSession: .init(configuration: config))
    let link = try XCTUnwrap(URL(string: "https://github.com/vercel/og-image"))
    let title = "alextsui05 starred vercel/og-image"

    sut.publisher(for: .pinAdd(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, title: title, link: link, cookie: keychain.cookie))
     .sink(
       receiveCompletion: { _ in },
       receiveValue: { _ in }
     )
     .cancel()
    usleep(1000)
    
    let request = try XCTUnwrap(LDRTestURLProtocol.requests.last)
    let url = try XCTUnwrap(request.url)
    XCTAssertEqual(url.absoluteString, "https://fastladder.com/api/pin/add")
    XCTAssertEqual(request.httpMethod, "POST")
    XCTAssertEqual(
      request.allHTTPHeaderFields,
      LDRRequestHeader.defaultHeader(url: url, body: ["ApiKey": "", "title": title, "link": link.absoluteString].HTTPBodyValue(), cookie: nil)
    )
  }
  
  func testLDRRequestPinAdd_whenSucceeding_LDRPinAddResponseIsSuccessShouldBeTrue() throws {
    var result: LDRPinAddResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRPinAddURLSessionSuccessFake()
    let link = try XCTUnwrap(URL(string: "https://github.com/vercel/og-image"))

    _ = sut.publisher(for: .pinAdd(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, title: "alextsui05 starred vercel/og-image", link: link, cookie: keychain.cookie))
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
    let sut = LDRPinAddURLSessionFailureFake()
    let link = try XCTUnwrap(URL(string: "https://github.com/vercel/og-image"))

    _ = sut.publisher(for: .pinAdd(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, title: "alextsui05 starred vercel/og-image", link: link, cookie: keychain.cookie))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.isSuccess == false)
  }
}

// MARK: - LDRPinAddURLSessionSuccessFake
struct LDRPinAddURLSessionSuccessFake: LDRURLSession {
  
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
  
  func response<LDRPinAddResponse>(
    for request: LDRRequest<LDRPinAddResponse>,
    using decoder: JSONDecoder = .init()
  ) async throws -> (LDRPinAddResponse, URLResponse) where LDRPinAddResponse: Decodable {
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let data = try XCTUnwrap("{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8))
    let response = try decoder.decode(LDRPinAddResponse.self, from: data)
    return (response, URLResponse())
  }
}

// MARK: - LDRPinAddURLSessionFailureFake
struct LDRPinAddURLSessionFailureFake: LDRURLSession {
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
  
  func response<LDRPinAddResponse>(
    for request: LDRRequest<LDRPinAddResponse>,
    using decoder: JSONDecoder = .init()
  ) async throws -> (LDRPinAddResponse, URLResponse) where LDRPinAddResponse: Decodable {
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let data = try XCTUnwrap("{\"ErrorCode\": 400, \"isSuccess\": false}".data(using: .utf8))
    let response = try decoder.decode(LDRPinAddResponse.self, from: data)
    return (response, URLResponse())
  }
}
