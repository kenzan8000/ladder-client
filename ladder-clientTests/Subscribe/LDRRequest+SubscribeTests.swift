import XCTest
@testable import ladder_client

// MARK: - LDRRequestSubscribeTests
class LDRRequestSubscribeTests: XCTestCase {
    // MARK: properties
    
    private let folders: [LDRRSSFolder] = [
        .init(id: 0, name: "Leave it uncategorized"),
        .init(id: 1, name: "company"),
        .init(id: 12, name: "news"),
        .init(id: 20, name: "jobs"),
        .init(id: 21, name: "books"),
        .init(id: 10, name: "friends"),
        .init(id: 9, name: "ios/mac"),
        .init(id: 4, name: "blogs"),
        .init(id: 23, name: "history/internationalism"),
    ]
    private let rates: [LDRRSSRate] = [
        .init(value: 0),
        .init(value: 1),
        .init(value: 2),
        .init(value: 3),
        .init(value: 4),
        .init(value: 5),
    ]
    
    // MARK: life cycle
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    // MARK: test
    
    func testGetSusbscribeResponse_whenLoadingCNNDotComHTML_shouldReturnAFeed() async throws {
        let sut = LDRDefaultSubscribeURLSession(urlSession: FakeURLSessoin(htmlFileName: "get-subscribe-cnn.com"))
        let keychain = LDRKeychainStub()
        let url = try XCTUnwrap(URL(string: "https://www.cnn.com"))
        let (response, _) = try await sut.response(for: .getSubscribe(
            feedUrl: url,
            apiKey: keychain.apiKey,
            ldrUrlString: keychain.ldrUrlString,
            cookie: keychain.cookie
        ))
        
        XCTAssertEqual(response.feeds.count, 1)
        XCTAssertNil(response.feeds.first?.id)
        XCTAssertEqual(response.feeds.first?.title, "CNN.com - RSS Channel - App International Edition")
        XCTAssertEqual(response.feeds.first?.url, URL(string: "http://rss.cnn.com/rss/edition.rss"))
        XCTAssertEqual(response.folders, folders)
        XCTAssertEqual(response.rates, rates)
    }
    
    func testGetSusbscribeResponse_whenLoadingKenzan8000DotOrgHTML_shouldReturnTwoFeeds() async throws {
        let sut = LDRDefaultSubscribeURLSession(urlSession: FakeURLSessoin(htmlFileName: "get-subscribe-kenzan8000.org"))
        let keychain = LDRKeychainStub()
        let url = try XCTUnwrap(URL(string: "https://kenzan8000.org"))
        let (response, _) = try await sut.response(for: .getSubscribe(
            feedUrl: url,
            apiKey: keychain.apiKey,
            ldrUrlString: keychain.ldrUrlString,
            cookie: keychain.cookie
        ))
        
        XCTAssertEqual(response.feeds.count, 2)
        XCTAssertEqual(response.feeds.first?.id, 17)
        XCTAssertEqual(response.feeds.first?.title, "Kenzan Hase")
        XCTAssertEqual(response.feeds.first?.url, URL(string: "https://kenzan8000.org/feed/"))
        XCTAssertNil(response.feeds.last?.id)
        XCTAssertEqual(response.feeds.last?.title, "\n\tComments for Kenzan Hase\t")
        XCTAssertEqual(response.feeds.last?.url, URL(string: "https://kenzan8000.org/comments/feed/"))
        XCTAssertEqual(response.folders, folders)
        XCTAssertEqual(response.rates, rates)
    }
    
    func testGetSusbscribeResponse_whenLoadingGithubDotComHTML_shouldRaiseError() async throws {
        let sut = LDRDefaultSubscribeURLSession(urlSession: FakeURLSessoin(htmlFileName: "get-subscribe-github.com"))
        let keychain = LDRKeychainStub()
        let url = try XCTUnwrap(URL(string: "https://github.com"))
        var raisedError: Error? = nil
        do {
            let (_, _) = try await sut.response(for: .getSubscribe(
                feedUrl: url,
                apiKey: keychain.apiKey,
                ldrUrlString: keychain.ldrUrlString,
                cookie: keychain.cookie
            ))
        } catch {
            raisedError = error
        }
        XCTAssertNotNil(raisedError)
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
