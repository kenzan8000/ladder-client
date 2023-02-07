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
  
  func testResponse_whenLoadingKenzan8000DotOrgHTML_shouldReturnProperFeeds() async throws {
    let sut = LDRDefaultRSSFeedURLSession(urlSession: FakeURLSessoin(htmlFileName: "rss-feed-kenzan8000.org"))
    let url = try XCTUnwrap(URL(string: "https://kenzan8000.org"))
    let (rssResponse, _) = try await sut.response(for: .rssFeed(url: url))

    XCTAssertEqual(rssResponse.feeds.first?.title, "Kenzan Hase » Feed")
    XCTAssertEqual(rssResponse.feeds.first?.url, URL(string: "https://kenzan8000.org/feed/"))
    XCTAssertEqual(rssResponse.feeds.last?.title, "Kenzan Hase » Comments Feed")
    XCTAssertEqual(rssResponse.feeds.last?.url, URL(string: "https://kenzan8000.org/comments/feed/"))
  }
  
  func testResponse_whenLoadingGoogleDotComHTML_shouldReturnNoFeeds() async throws {
    let sut = LDRDefaultRSSFeedURLSession(urlSession: FakeURLSessoin(htmlFileName: "rss-feed-google.com"))
    let url = try XCTUnwrap(URL(string: "https://google.com"))
    let (rssResponse, _) = try await sut.response(for: .rssFeed(url: url))
    XCTAssertTrue(rssResponse.feeds.isEmpty)
  }
}

private struct FakeURLSessoin: URLSessionProtocol {
  let htmlFileName: String
  
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    let url = try XCTUnwrap(Bundle(for: type(of: LDRRequestRSSFeedTests())).url(forResource: htmlFileName, withExtension: "html"))
    let data = try Data(contentsOf: url, options: .uncached)
    return (data, URLResponse())
  }
}
