import XCTest
@testable import ladder_client

// MARK: - LDRRequestSubscribeTests
class LDRRequestSubscribeTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testGetSusbscribeResponse_whenLoadingCNNFeedHTML_shouldReturnAFeed() async throws {
    let sut = LDRDefaultSubscribeURLSession(urlSession: FakeURLSessoin(htmlFileName: "get-subscribe-cnn.com"))
    let keychain = LDRKeychainStub()
    let url = try XCTUnwrap(URL(string: "https://www.cnn.com"))
    let (response, _) = try await sut.response(for: .getSubscribe(
      feedUrl: url,
      apiKey: keychain.apiKey,
      ldrUrlString: keychain.ldrUrlString,
      cookie: keychain.cookie
    ))
    
    XCTAssertEqual(response.feeds.first?.title, "CNN.com - RSS Channel - App International Edition")
    XCTAssertEqual(response.feeds.first?.url, URL(string: "http://rss.cnn.com/rss/edition.rss"))
  }
}

private struct FakeURLSessoin: URLSessionProtocol {
  let htmlFileName: String
  
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    let url = try XCTUnwrap(Bundle(for: type(of: LDRRequestSubscribeTests())).url(forResource: htmlFileName, withExtension: "html"))
    let data = try Data(contentsOf: url, options: .uncached)
    return (data, URLResponse())
  }
}
