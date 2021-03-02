import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequestSessionTests
class LDRRequestSessionTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestSession_whenValidHtml_apiKeyIsValid() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeValidHtmlPublisher(
      for: .session(username: "username", password: "password", authenticityToken: "authenticityToken")
    )
    
    _ = sut
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertTrue(result?.apiKey == mockApiKey)
  }
  
  func testLDRRequestSession_whenEmptyHtml_apiKeyIsEmpty() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeEmptyHtmlPublisher(
      for: .session(username: "username", password: "password", authenticityToken: "authenticityToken")
    )
    
    _ = sut
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

// MARK: - URLSession + Fake
extension URLSession {
  func fakeValidHtmlPublisher(for request: LDRRequest<LDRSessionResponse>) -> AnyPublisher<LDRSessionResponse, Swift.Error> {
    Future<LDRSessionResponse, Swift.Error> { promise in
      if let url = Bundle(for: type(of: LDRRequestSessionTests())).url(forResource: "session", withExtension: "html"),
         let data = try? Data(contentsOf: url, options: .uncached) {
        promise(.success(LDRSessionResponse(data: data)))
      } else {
        promise(.failure(LDRError.failed("Failed to load local html file.")))
      }
    }
    .eraseToAnyPublisher()
  }
  
  func fakeEmptyHtmlPublisher(for request: LDRRequest<LDRSessionResponse>) -> AnyPublisher<LDRSessionResponse, Swift.Error> {
    Future<LDRSessionResponse, Swift.Error> { promise in
      promise(.success(LDRSessionResponse(data: Data())))
    }
    .eraseToAnyPublisher()
  }
}
