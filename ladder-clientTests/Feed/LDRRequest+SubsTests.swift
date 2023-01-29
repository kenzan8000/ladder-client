import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+SubsTests
class LDRRequestSubsTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
    LDRTestURLProtocol.requests = []
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  func testLDRRequestSubs_whenUsingLDRTestURLProtocol_requestShouldBeValid() throws {
    let config = URLSessionConfiguration.default
    config.protocolClasses = [LDRTestURLProtocol.self]
    let keychain = LDRKeychainStub()
    keychain.ldrUrlString = "fastladder.com"
    let sut = LDRDefaultURLSession(keychain: keychain, urlSession: .init(configuration: config))
    
    sut.publisher(for: LDRRequest.subs(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, cookie: keychain.cookie))
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { _ in }
      )
      .cancel()
    usleep(1000)
    
    let request = try XCTUnwrap(LDRTestURLProtocol.requests.last)
    let url = try XCTUnwrap(request.url)
    XCTAssertEqual(url.absoluteString, "https://fastladder.com/api/subs?unread=1")
    XCTAssertEqual(request.httpMethod, "POST")
    XCTAssertEqual(
      request.allHTTPHeaderFields,
      LDRRequestHeader.defaultHeader(url: url, body: ["ApiKey": ""].HTTPBodyValue(), cookie: nil)
    )
  }
  
  func testLDRRequestSubs_whenValidJsonResponse_LDRSubsResponseShouldBeValid() throws {
    var result: LDRSubsResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRSubsURLSessionFake()

    _ = sut.publisher(for: .subs(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, cookie: keychain.cookie))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.count == 6)
  }
}

// MARK: - LDRSubsURLSessionFake
struct LDRSubsURLSessionFake: LDRURLSession  {
  func publisher<LDRSubsResponse>(
    for request: LDRRequest<LDRSubsResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRSubsResponse, LDRError> where LDRSubsResponse: Decodable {
    Future<LDRSubsResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let url = try! XCTUnwrap(Bundle(for: type(of: LDRRequestSubsTests())).url(forResource: "subs", withExtension: "json"))
      let data = try! Data(contentsOf: url, options: .uncached)
      let response = try! decoder.decode(LDRSubsResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
  
  func data(from url: URL) async throws -> (Data, URLResponse) {
    let url = try XCTUnwrap(Bundle(for: type(of: LDRRequestSubsTests())).url(forResource: "subs", withExtension: "json"))
    let data = try Data(contentsOf: url, options: .uncached)
    return (
      try XCTUnwrap(data),
      URLResponse()
    )
  }
}
