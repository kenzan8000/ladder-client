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
  
  func testLDRRequestSession_whenInitialState_retrieveValidApiKey() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let sut = URLSession.shared.fakeSuccessPublisher(
      for: .session(username: "username", password: "password", authenticityToken: "authenticityToken")
    )
    
    _ = sut
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertTrue(result?.apiKey == "88ea15c16fc915fc27392b7dedc17382")
  }
}

// MARK: - URLSession + Mock
extension URLSession {
  func fakeSuccessPublisher(for request: LDRRequest<LDRSessionResponse>) -> AnyPublisher<LDRSessionResponse, Swift.Error> {
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
}
