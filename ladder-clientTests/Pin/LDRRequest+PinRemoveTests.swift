import Combine
import Foundation
import XCTest
@testable import ladder_client

// MARK: - LDRRequest+PinRemoveTests
class LDRRequestPinRemoveTests: XCTestCase {

    // MARK: life cycle
    
    override func setUpWithError() throws {
        super.setUp()
        LDRTestURLProtocol.requests = []
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    // MARK: test
    func testLDRRequestPinRemove_whenUsingLDRTestURLProtocol_requestShouldBeValid() throws {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [LDRTestURLProtocol.self]
        let keychain = LDRKeychainStub()
        keychain.ldrUrlString = "fastladder.com"
        let sut = LDRDefaultURLSession(keychain: keychain, urlSession: .init(configuration: config))
        let link = try XCTUnwrap(URL(string: "https://github.com/vercel/og-image"))
        
        sut.publisher(for: .pinRemove(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, link: link, cookie: keychain.cookie))
         .sink(
             receiveCompletion: { _ in },
             receiveValue: { _ in }
         )
         .cancel()
        usleep(1000)
        
        let request = try XCTUnwrap(LDRTestURLProtocol.requests.last)
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "https://fastladder.com/api/pin/remove")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(
            request.allHTTPHeaderFields,
            LDRRequestHeader.defaultHeader(url: url, body: ["ApiKey": "", "link": link.absoluteString].HTTPBodyValue(), cookie: nil)
        )
    }
    
    func testLDRRequestPinRemove_whenSucceeding_LDRPinRemoveResponseIsSuccessShouldBeTrue() throws {
        var result: LDRPinRemoveResponse? = nil
        let exp = expectation(description: #function)
        let keychain = LDRKeychainStub()
        let sut = LDRPinRemoveURLSessionSuccessFake()
        let link = try XCTUnwrap(URL(string: "https://github.com/vercel/og-image"))

        _ = sut.publisher(for: .pinRemove(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, link: link, cookie: keychain.cookie))
            .sink(
                receiveCompletion: { _ in exp.fulfill() },
                receiveValue: { result = $0 }
            )
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.isSuccess == true)
    }
    
    func testLDRRequestPinRemove_whenFailing_LDRPinRemoveResponseIsSuccessShouldBeFalse() throws {
        var result: LDRPinRemoveResponse? = nil
        let exp = expectation(description: #function)
        let keychain = LDRKeychainStub()
        let sut = LDRPinRemoveURLSessionFailureFake()
        let link = try XCTUnwrap(URL(string: "https://github.com/vercel/og-image"))

        _ = sut.publisher(for: .pinRemove(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, link: link, cookie: keychain.cookie))
            .sink(
                receiveCompletion: { _ in exp.fulfill() },
                receiveValue: { result = $0 }
            )
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.isSuccess == false)
    }
}

// MARK: - LDRPinRemoveURLSessionSuccessFake
struct LDRPinRemoveURLSessionSuccessFake: LDRURLSession {
    func publisher<LDRPinRemoveResponse>(
        for request: LDRRequest<LDRPinRemoveResponse>,
        using decoder: JSONDecoder = .init()
    ) -> AnyPublisher<LDRPinRemoveResponse, LDRError> where LDRPinRemoveResponse: Decodable {
        Future<LDRPinRemoveResponse, LDRError> { promise in
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let data = try! XCTUnwrap("{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8))
            let response = try! decoder.decode(LDRPinRemoveResponse.self, from: data)
            promise(.success(response))
        }
        .eraseToAnyPublisher()
    }
    
    func response<LDRPinRemoveResponse>(
        for request: LDRRequest<LDRPinRemoveResponse>,
        using decoder: JSONDecoder = .init()
    ) async throws -> (LDRPinRemoveResponse, URLResponse) where LDRPinRemoveResponse: Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = try XCTUnwrap("{\"ErrorCode\": 0, \"isSuccess\": true}".data(using: .utf8))
        let response = try decoder.decode(LDRPinRemoveResponse.self, from: data)
        return (response, URLResponse())
    }
}

// MARK: - LDRPinRemoveURLSessionFailureFake
struct LDRPinRemoveURLSessionFailureFake: LDRURLSession {
    func publisher<LDRPinRemoveResponse>(
        for request: LDRRequest<LDRPinRemoveResponse>,
        using decoder: JSONDecoder = .init()
    ) -> AnyPublisher<LDRPinRemoveResponse, LDRError> where LDRPinRemoveResponse: Decodable {
        Future<LDRPinRemoveResponse, LDRError> { promise in
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let data = try! XCTUnwrap("{\"ErrorCode\": 400, \"isSuccess\": false}".data(using: .utf8))
            let response = try! decoder.decode(LDRPinRemoveResponse.self, from: data)
            promise(.success(response))
        }
        .eraseToAnyPublisher()
    }
    
    func response<LDRPinRemoveResponse>(
        for request: LDRRequest<LDRPinRemoveResponse>,
        using decoder: JSONDecoder = .init()
    ) async throws -> (LDRPinRemoveResponse, URLResponse) where LDRPinRemoveResponse: Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = try XCTUnwrap("{\"ErrorCode\": 400, \"isSuccess\": false}".data(using: .utf8))
        let response = try decoder.decode(LDRPinRemoveResponse.self, from: data)
        return (response, URLResponse())
    }
}
