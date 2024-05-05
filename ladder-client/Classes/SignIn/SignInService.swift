import Foundation
import HTMLReader
import JavaScriptCore

// MARK: - SignInService

class SignInService: SignInServiceProtocol {
    // MARK: - Private properties

    private var keychain: any KeychainProtocol

    private let networking: any SignInNetworkingProtocol

    private let cookieStorage: any CookieStorageProtocol

    // MARK: - Init

    init(
        keychain: any KeychainProtocol,
        networking: any SignInNetworkingProtocol,
        cookieStorage: any CookieStorageProtocol
    ) {
        self.keychain = keychain
        self.networking = networking
        self.cookieStorage = cookieStorage
    }

    // MARK: - Public methods

    @MainActor
    func signIn(username: String, password: String) async throws {
        // Retrieve "authenticity_token" from signin page HTML
        let (signInData, _) = try await networking.signIn(username: username, password: password)
        let authenticityToken = HTMLDocument(data: signInData, contentTypeHeader: nil)
            .firstNode(matchingSelector: "form")?.children
            .compactMap { $0 as? HTMLElement }
            .compactMap { (element: HTMLElement) in
                element["name"] == "authenticity_token" ? element["value"] : nil
            }
            .reduce("", +)
        guard let authenticityToken else {
            throw NetworkingError.noAuthenticityToken
        }

        // Call session endpoint with the "authenticity_token" and get apiKey from the response HTML
        let (sessionData, sessionResponse) = try await networking.session(username: username, password: password, authenticityToken: authenticityToken)
        let apiKey = HTMLDocument(data: sessionData, contentTypeHeader: nil)
            .nodes(matchingSelector: "script")
            .flatMap { $0.children }
            .compactMap { $0 as? HTMLNode }
            .compactMap { (htmlNode: HTMLNode) -> String? in
                guard let jsContext = JSContext() else {
                    return nil
                }
                jsContext.evaluateScript(htmlNode.textContent)
                jsContext.evaluateScript("let getApiKey = () => { return ApiKey }")
                guard let key = jsContext.evaluateScript("getApiKey()").toString(),
                key != "undefined" else {
                    return nil
                }
                return key
            }
            .reduce("", +)
        if apiKey.isEmpty {
            throw NetworkingError.noAPIKey
        }
        keychain.apiKey = apiKey
        cookieStorage.addCookies(urlResponse: sessionResponse)
        keychain.cookie = cookieStorage.cookieString(host: sessionResponse.url?.host)
    }

    func cancel() {
        networking.cancel()
    }
}
