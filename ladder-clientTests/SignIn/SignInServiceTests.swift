import XCTest
@testable import ladder_client

// MARK: - SignInServiceTests

final class SignInServiceTests: XCTestCase {
    // MARK: - Tests
    
    func testIsSignedIn_whenRootURLIsEqualToNil_shouldReturnFalse() {
        let keychain = KeychainMock()
        keychain.rootURL = nil
        let service = SignInService(keychain: keychain, networking: makeNetworking(), cookieStorage: CookieStorageMock())
        XCTAssertNil(keychain.rootURL)
        XCTAssertFalse(service.isSignedIn)
    }
    
    func testIsSignedIn_whenAPIKeyIsEqualToNil_shouldReturnFalse() {
        let keychain = KeychainMock()
        keychain.apiKey = nil
        let service = SignInService(keychain: keychain, networking: makeNetworking(), cookieStorage: CookieStorageMock())
        XCTAssertNil(keychain.apiKey)
        XCTAssertFalse(service.isSignedIn)
    }
    
    func testIsSignedIn_whenCookieIsEqualToNil_shouldReturnFalse() {
        let keychain = KeychainMock()
        keychain.cookie = nil
        let service = SignInService(keychain: keychain, networking: makeNetworking(), cookieStorage: CookieStorageMock())
        XCTAssertNil(keychain.cookie)
        XCTAssertFalse(service.isSignedIn)
    }
    
    func testIsSignedIn_whenRootURLIsNotEqualToNilAndAPIKeyIsNotEqualToNilAndCookieIsNotEqualToNil_shouldReturnTrue() throws {
        let keychain = KeychainMock()
        keychain.rootURL = try XCTUnwrap(URL(string: "https://test.com"))
        keychain.apiKey = "api key"
        keychain.cookie = "cookie"
        let service = SignInService(keychain: keychain, networking: makeNetworking(), cookieStorage: CookieStorageMock())
        XCTAssertNotNil(keychain.rootURL)
        XCTAssertNotNil(keychain.apiKey)
        XCTAssertNotNil(keychain.cookie)
        XCTAssertTrue(service.isSignedIn)
    }
    
    func testIsSignedIn_afterSignOut_shouldReturnFalse() throws {
        let keychain = KeychainMock()
        keychain.rootURL = try XCTUnwrap(URL(string: "https://test.com"))
        keychain.apiKey = "api key"
        keychain.cookie = "cookie"
        let service = SignInService(keychain: keychain, networking: makeNetworking(), cookieStorage: CookieStorageMock())
        XCTAssertTrue(service.isSignedIn)
        service.signOut()
        XCTAssertFalse(service.isSignedIn)
    }
    
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
