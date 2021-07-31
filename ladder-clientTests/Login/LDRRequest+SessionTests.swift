import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+SessionTests
class LDRRequestSessionTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
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
