import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+SessionTests
class LDRRequestSessionTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
    LDRTestURLProtocol.requests = []
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  func testLDRRequestSession_whenUsingLDRTestURLProtocol_requestShouldBeValid() throws {
    let config = URLSessionConfiguration.default
    config.protocolClasses = [LDRTestURLProtocol.self]
    let keychain = LDRKeychainStub()
    keychain.ldrUrlString = "fastladder.com"
    let sut = URLSession(configuration: config)

    sut.publisher(for: .session(ldrUrlString: keychain.ldrUrlString, username: "username", password: "password", authenticityToken: "authenticityToken"))
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { _ in }
      )
      .cancel()
    usleep(1000)
    
    let request = try XCTUnwrap(LDRTestURLProtocol.requests.last)
    let url = try XCTUnwrap(request.url)
    XCTAssertEqual(url.absoluteString, "https://fastladder.com/session")
    XCTAssertEqual(request.httpMethod, "POST")
    XCTAssertEqual(
      request.allHTTPHeaderFields,
      LDRRequestHeader.cookielessHeader(body: ["username": "username", "password": "password", "authenticity_token": "authenticityToken"].HTTPBodyValue())
    )
  }
  
  func testLDRRequestSession_whenValidHtml_apiKeyShouldBeValid() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRSessionURLSessionSuccessFake()
    
    _ = sut
      .publisher(
        for: .session(ldrUrlString: keychain.ldrUrlString, username: "username", password: "password", authenticityToken: "authenticityToken")
      )
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertTrue(result?.apiKey == apiKey)
  }
  
  func testLDRRequestSession_whenEmptyHtml_apiKeyShouldBeEmpty() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRSessionURLSessionFailureFake()
    
    _ = sut
      .publisher(
        for: .session(ldrUrlString: keychain.ldrUrlString, username: "username", password: "password", authenticityToken: "authenticityToken")
      )
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    wait(for: [exp], timeout: 0.1)
    XCTAssertTrue(result?.apiKey == "")
  }
}

// MARK: - Test Data
private let apiKey = "88ea15c16fc915fc27392b7dedc17382"

// MARK: - LDRSessionURLSessionSuccessFake
struct LDRSessionURLSessionSuccessFake: LDRSessionURLSession {
  func publisher(
    for request: LDRRequest<LDRSessionResponse>
  ) -> AnyPublisher<LDRSessionResponse, LDRError> {
    Future<LDRSessionResponse, LDRError> { promise in
      let url = try! XCTUnwrap(Bundle(for: type(of: LDRRequestSessionTests())).url(forResource: "session", withExtension: "html"))
      let data = try! Data(contentsOf: url, options: .uncached)
      promise(.success(LDRSessionResponse(data: data)))
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - LDRSessionURLSessionFailureFake
struct LDRSessionURLSessionFailureFake: LDRSessionURLSession {
  func publisher(
    for request: LDRRequest<LDRSessionResponse>
  ) -> AnyPublisher<LDRSessionResponse, LDRError> {
    Future<LDRSessionResponse, LDRError> { promise in
      promise(.success(LDRSessionResponse(data: Data())))
    }
    .eraseToAnyPublisher()
  }
}
