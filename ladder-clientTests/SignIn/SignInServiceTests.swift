import XCTest
@testable import ladder_client

// MARK: - SignInServiceTests

final class SignInServiceTests: XCTestCase {
    // MARK: - Tests

    func testSignIn_whenSignInHTMLDoesNotHaveAuthenticityToken_shouldThrowNoAuthenticityTokenError() async throws {
        let networking = makeNetworking(signInHTMLData: Data())
        let service = SignInService(keychain: KeychainMock(), networking: networking, cookieStorage: CookieStorageMock())
        var thrownError: Error?
        do {
            try await service.signIn(username: "username", password: "password")
        } catch {
            thrownError = error
        }
        XCTAssertEqual(
            try XCTUnwrap(thrownError as? NetworkingError),
            NetworkingError.noAuthenticityToken
        )
    }
    
    func testSignIn_whenSessionHTMLDoesNotHaveApiKey_shouldThrowNoApiKeyError() async throws {
        let networking = makeNetworking(signInHTMLData: .signInHTMLData, sessionHTMLData: Data())
        let service = SignInService(keychain: KeychainMock(), networking: networking, cookieStorage: CookieStorageMock())
        var thrownError: Error?
        do {
            try await service.signIn(username: "username", password: "password")
        } catch {
            thrownError = error
        }
        XCTAssertEqual(
            try XCTUnwrap(thrownError as? NetworkingError),
            NetworkingError.noAPIKey
        )
    }

    func testSignIn_whenSignInSucceeds_shouldKeychainHaveApiKeyAndCookie() async throws {
        let keychain = KeychainMock()
        let networking = makeNetworking(signInHTMLData: .signInHTMLData, sessionHTMLData: .sessionHTMLData, sessionResponse: HTTPURLResponse.sessionResponse)
        let service = SignInService(keychain: keychain, networking: networking, cookieStorage: CookieStorageMock())
        XCTAssertNil(keychain.apiKey)
        XCTAssertNil(keychain.cookie)
        try await service.signIn(username: "username", password: "password")
        XCTAssertEqual(keychain.apiKey, .sessionHTMLApiKey)
        XCTAssertEqual(keychain.cookie, .sessionResponseCookie)
    }

    // MARK: - Helpers
    
    private func makeNetworking(
        signInHTMLData: Data = Data(),
        sessionHTMLData: Data = Data(),
        sessionResponse: URLResponse = URLResponse()
    ) -> SignInNetworkingMock {
        let networking = SignInNetworkingMock()
        networking.signInHTMLData = signInHTMLData
        networking.sessionHTMLData = sessionHTMLData
        networking.sessionResponse = sessionResponse
        return networking
    }
}
