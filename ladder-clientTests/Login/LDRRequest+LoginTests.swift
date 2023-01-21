import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+LoginTests
class LDRRequestLoginTests: XCTestCase {

  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
    LDRTestURLProtocol.requests = []
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  // MARK: test
  func testLDRRequestLogin_whenUsingLDRTestURLProtocol_requestShouldBeValid() throws {
    let config = URLSessionConfiguration.default
    config.protocolClasses = [LDRTestURLProtocol.self]
    let keychain = LDRKeychainStub()
    keychain.ldrUrlString = "fastladder.com"
    let sut = LDRDefaultLoginURLSession(keychain: keychain, urlSession: .init(configuration: config))
    
    sut.publisher(
        for: .login(ldrUrlString: keychain.ldrUrlString, username: "username", password: "password"),
        ldrUrlString: keychain.ldrUrlString
      )
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { _ in }
      )
      .cancel()
    usleep(1000)
    
    let request = try XCTUnwrap(LDRTestURLProtocol.requests.last)
    let url = try XCTUnwrap(request.url)
    XCTAssertEqual(url.absoluteString, "https://fastladder.com/login?username=username&password=password")
    XCTAssertEqual(request.httpMethod, "GET")
  }
  
  func testLDRRequestLogin_whenValidHtml_apiKeyShouldBeValid() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRLoginURLSessionValidFake()
    
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
    XCTAssertTrue(result?.apiKey == apiKey)
  }
  
  func testLDRRequestLogin_whenEmptyHtml_apiKeyShouldBeEmpty() throws {
    var result: LDRSessionResponse? = nil
    let exp = expectation(description: #function)
    let keychain = LDRKeychainStub()
    let sut = LDRLoginURLSessionInvalidFake()
    
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
    let sut: LDRLoginResponse? = try .fakeValidResponse()
    XCTAssertTrue(sut?.authencityToken == authencityToken)
  }
  
  func testLDRLoginResponse_whenEmptyHtml_authencityTokenShouldBeEmpty() throws {
    let sut: LDRLoginResponse? = .fakeEmptyResponse
    XCTAssertTrue(sut?.authencityToken == "")
  }
}

// MARK: - Test Data
private let apiKey = "88ea15c16fc915fc27392b7dedc17382"
private let authencityToken = "Fnfu3ODtX/l7TozdDm7425yHGHJqQ+7Oc43XShAQExIR5+ZsAvXZOK8jpdc9Gx+HXIxCwfZTSvYH5MkJ1QoZ2Q=="

// MARK: - LDRLoginURLSessionValidFake
struct LDRLoginURLSessionValidFake: LDRLoginURLSession {
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

// MARK: - LDRLoginURLSessionInvalidFake
struct LDRLoginURLSessionInvalidFake: LDRLoginURLSession {
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
  static func fakeValidResponse() throws -> LDRLoginResponse? {
    let htmlUrl = try XCTUnwrap(Bundle(for: type(of: LDRRequestLoginTests())).url(forResource: "login", withExtension: "html"))
    let data = try XCTUnwrap(try Data(contentsOf: htmlUrl, options: .uncached))
    let url = try XCTUnwrap(URL(string: "https://example.com/login?username=username&password=password"))
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
