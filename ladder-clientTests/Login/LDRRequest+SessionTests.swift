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
    let sut = LDRSessionURLSessionSuccessMock()
    
    _ = sut
      .publisher(
        for: .session(ldrUrlString: keychain.ldrUrlString, username: "username", password: "password", authenticityToken: "authenticityToken")
      )
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertTrue(result?.apiKey == mockApiKey)
  }
  
  func testLDRRequestSession_whenEmptyHtml_apiKeyShouldBeEmpty() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRSessionURLSessionFailureMock()
    
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

// MARK: - Mock
private let mockApiKey = "88ea15c16fc915fc27392b7dedc17382"

// MARK: - LDRSessionURLSessionSuccessMock
struct LDRSessionURLSessionSuccessMock: LDRSessionURLSession {
  func publisher(
    for request: LDRRequest<LDRSessionResponse>
  ) -> AnyPublisher<LDRSessionResponse, LDRError> {
    Future<LDRSessionResponse, LDRError> { promise in
      let url = Bundle(for: type(of: LDRRequestSessionTests())).url(forResource: "session", withExtension: "html")!
      let data = try! Data(contentsOf: url, options: .uncached)
      promise(.success(LDRSessionResponse(data: data)))
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - LDRSessionURLSessionFailureMock
struct LDRSessionURLSessionFailureMock: LDRSessionURLSession {
  func publisher(
    for request: LDRRequest<LDRSessionResponse>
  ) -> AnyPublisher<LDRSessionResponse, LDRError> {
    Future<LDRSessionResponse, LDRError> { promise in
      promise(.success(LDRSessionResponse(data: Data())))
    }
    .eraseToAnyPublisher()
  }
}
