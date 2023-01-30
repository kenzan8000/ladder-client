import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+UnreadTests
class LDRRequestUnreadTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
    LDRTestURLProtocol.requests = []
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  func testLDRRequestUnread_whenUsingLDRTestURLProtocol_requestShouldBeValid() throws {
    let subscribeId = 50
    let config = URLSessionConfiguration.default
    config.protocolClasses = [LDRTestURLProtocol.self]
    let keychain = LDRKeychainStub()
    keychain.ldrUrlString = "fastladder.com"
    let sut = LDRDefaultURLSession(keychain: keychain, urlSession: .init(configuration: config))

    sut.publisher(for: .unread(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, subscribeId: subscribeId, cookie: keychain.cookie))
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { _ in }
      )
      .cancel()
    usleep(1000)
    
    let request = try XCTUnwrap(LDRTestURLProtocol.requests.last)
    let url = try XCTUnwrap(request.url)
    XCTAssertEqual(url.absoluteString, "https://fastladder.com/api/unread")
    XCTAssertEqual(request.httpMethod, "POST")
    XCTAssertEqual(
      request.allHTTPHeaderFields,
      LDRRequestHeader.defaultHeader(url: url, body: ["ApiKey": "", "subscribe_id": "\(subscribeId)"].HTTPBodyValue(), cookie: nil)
    )
  }
 
  func testLDRRequestUnread_whenValidJsonResponse_LDRUnreadResponseShouldBeValid() throws {
    let subscribeId = 50
    var result: LDRUnreadResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRUnreadURLSessionFake()

    _ = sut.publisher(for: .unread(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, subscribeId: subscribeId, cookie: keychain.cookie))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.subscribeId == subscribeId)
  }
}

// MARK: - LDRUnreadURLSessionFake
struct LDRUnreadURLSessionFake: LDRURLSession {
  func publisher<LDRUnreadResponse>(
    for request: LDRRequest<LDRUnreadResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRUnreadResponse, LDRError> where LDRUnreadResponse: Decodable {
    Future<LDRUnreadResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let url = try! XCTUnwrap(Bundle(for: type(of: LDRRequestUnreadTests())).url(forResource: "unread", withExtension: "json"))
      let data = try! Data(contentsOf: url, options: .uncached)
      let response = try! decoder.decode(LDRUnreadResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
  
  func response<LDRUnreadResponse>(
    for request: LDRRequest<LDRUnreadResponse>,
    using decoder: JSONDecoder = .init()
  ) async throws -> (LDRUnreadResponse, URLResponse) where LDRUnreadResponse: Decodable {
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let url = try XCTUnwrap(Bundle(for: type(of: LDRRequestUnreadTests())).url(forResource: "unread", withExtension: "json"))
    let data = try Data(contentsOf: url, options: .uncached)
    let response = try decoder.decode(LDRUnreadResponse.self, from: data)
    return (response, URLResponse())
  }
}
