import XCTest
@testable import ladder_client

// MARK: - LDRRequestRSSFeedTests
class LDRRequestRSSFeedTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testResponse_whenLoadingLocalHTML_shouldReturnProperFeeds() async throws {
    let sut = LDRDefaultRSSFeedURLSession(urlSession: FakeURLSessoin())
    let url = try XCTUnwrap(URL(string: "https://kenzan8000.org"))
    let (rssResponse, _) = try await sut.response(for: .rssFeed(url: url))
    
    XCTAssertEqual(rssResponse.feeds.first?.title, "Kenzan Hase » Feed")
    XCTAssertEqual(rssResponse.feeds.first?.url, URL(string: "https://kenzan8000.org/feed/"))
    XCTAssertEqual(rssResponse.feeds.last?.title, "Kenzan Hase » Comments Feed")
    XCTAssertEqual(rssResponse.feeds.last?.url, URL(string: "https://kenzan8000.org/comments/feed/"))
  }
}

private struct FakeURLSessoin: URLSessionProtocol {
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    let url = try XCTUnwrap(Bundle(for: type(of: LDRRequestRSSFeedTests())).url(forResource: "rss-feeds", withExtension: "html"))
    let data = try Data(contentsOf: url, options: .uncached)
    return (data, URLResponse())
  }
}
