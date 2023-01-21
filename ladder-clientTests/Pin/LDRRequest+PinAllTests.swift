import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+PinAllTests
class LDRRequestPinAllTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
    LDRTestURLProtocol.requests = []
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  func testLDRRequestPinAll_whenUsingLDRTestURLProtocol_requestShouldBeValid() throws {
    let config = URLSessionConfiguration.default
    config.protocolClasses = [LDRTestURLProtocol.self]
    let keychain = LDRKeychainStub()
    keychain.ldrUrlString = "fastladder.com"
    let sut = URLSession(configuration: config)
    
    sut.publisher(for: .pinAll(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, cookie: keychain.cookie))
     .sink(
       receiveCompletion: { _ in },
       receiveValue: { _ in }
     )
     .cancel()
    usleep(1000)
    
    let request = try XCTUnwrap(LDRTestURLProtocol.requests.last)
    let url = try XCTUnwrap(request.url)
    XCTAssertEqual(url.absoluteString, "https://fastladder.com/api/pin/all")
    XCTAssertEqual(request.httpMethod, "POST")
    XCTAssertEqual(
      request.allHTTPHeaderFields,
      LDRRequestHeader.defaultHeader(url: url, body: ["ApiKey": ""].HTTPBodyValue(), cookie: nil)
    )
  }
  
  func testLDRRequestPinAll_whenValidJsonResponse_LDRPinAllResponseShouldBeValid() throws {
    var result: LDRPinAllResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRPinAllURLSessionFake()

    _ = sut.publisher(for: .pinAll(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, cookie: keychain.cookie))
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertNotNil(result)
    XCTAssertTrue(result?.count == 5)
  }
}

// MARK: - LDRPinAllURLSessionFake
struct LDRPinAllURLSessionFake: LDRURLSession {
  func publisher<LDRPinAllResponse>(
    for request: LDRRequest<LDRPinAllResponse>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<LDRPinAllResponse, LDRError> where LDRPinAllResponse: Decodable {
    Future<LDRPinAllResponse, LDRError> { promise in
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let url = try! XCTUnwrap(Bundle(for: type(of: LDRRequestPinAllTests())).url(forResource: "pinAll", withExtension: "json"))
      let data = try! Data(contentsOf: url, options: .uncached)
      let response = try! decoder.decode(LDRPinAllResponse.self, from: data)
      promise(.success(response))
    }
    .eraseToAnyPublisher()
  }
}
