import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+LoginTests
class LDRRequestLoginTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  
  func testLDRRequestLogin_whenValidHtml_apiKeyShouldBeValid() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRLoginURLSessionValidMock()
    
    _ = sut
      .publisher(
        for: .login(ldrUrlString: keychain.ldrUrlString, username: "username", password: "password"),
        ldrUrlString: keychain.ldrUrlString
      )
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    
    wait(for: [exp], timeout: 0.1)
    XCTAssertTrue(result?.apiKey == mockApiKey)
  }
  
  func testLDRRequestLogin_whenEmptyHtml_apiKeyShouldBeEmpty() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRLoginURLSessionInvalidMock()
    
    _ = sut
      .publisher(
        for: .login(ldrUrlString: keychain.ldrUrlString, username: "username", password: "password"),
        ldrUrlString: keychain.ldrUrlString
      )
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
    wait(for: [exp], timeout: 0.1)
    XCTAssertTrue(result?.apiKey == "")
  }
  
  func testLDRLoginResponse_whenValidHtml_authencityTokenShouldBeValid() throws {
    let sut: LDRLoginResponse? = .fakeValidResponse()
    XCTAssertTrue(sut?.authencityToken == mockAuthencityToken)
  }
  
  func testLDRLoginResponse_whenEmptyHtml_authencityTokenShouldBeEmpty() throws {
    let sut: LDRLoginResponse? = .fakeEmptyResponse
    XCTAssertTrue(sut?.authencityToken == "")
  }
}

// MARK: - Mock
private let mockApiKey = "88ea15c16fc915fc27392b7dedc17382"
private let mockAuthencityToken = "Fnfu3ODtX/l7TozdDm7425yHGHJqQ+7Oc43XShAQExIR5+ZsAvXZOK8jpdc9Gx+HXIxCwfZTSvYH5MkJ1QoZ2Q=="

// MARK: - LDRLoginURLSessionValidMock
struct LDRLoginURLSessionValidMock: LDRLoginURLSession {
  func publisher(
    for request: LDRRequest<LDRLoginResponse>,
    ldrUrlString: String?
  ) -> AnyPublisher<LDRSessionResponse, LDRError> {
    Future<LDRSessionResponse, LDRError> { promise in
      let url = try! XCTUnwrap(Bundle(for: type(of: LDRRequestLoginTests())).url(forResource: "session", withExtension: "html"))
      let data = try! Data(contentsOf: url, options: .uncached)
      promise(.success(LDRSessionResponse(data: data)))
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - LDRLoginURLSessionInvalidMock
struct LDRLoginURLSessionInvalidMock: LDRLoginURLSession {
  func publisher(
    for request: LDRRequest<LDRLoginResponse>,
    ldrUrlString: String?
  ) -> AnyPublisher<LDRSessionResponse, LDRError> {
    Future<LDRSessionResponse, LDRError> { promise in
      promise(.success(LDRSessionResponse(data: Data())))
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - LDRLoginResponse + Fake
extension LDRLoginResponse {
  static func fakeValidResponse() -> LDRLoginResponse? {
    let htmlUrl = try! XCTUnwrap(Bundle(for: type(of: LDRRequestLoginTests())).url(forResource: "login", withExtension: "html"))
    let data = try! Data(contentsOf: htmlUrl, options: .uncached)
    let url = URL(string: "https://example.com/login?username=username&password=password")!
    return LDRLoginResponse(
      data: data,
      response: URLResponse(
        url: url,
        mimeType: "text/html",
        expectedContentLength: -1,
        textEncodingName: "utf-8"
      )
    )
  }
  
  static let fakeEmptyResponse = LDRLoginResponse(
    data: Data(),
    response: URLResponse(
      url: URL(fileURLWithPath: ""),
      mimeType: "text/html",
      expectedContentLength: -1,
      textEncodingName: "utf-8"
    )
  )
}
