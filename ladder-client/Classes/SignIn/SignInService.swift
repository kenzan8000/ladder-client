import Combine
import Foundation
import HTMLReader
import JavaScriptCore

// MARK: - SignInService

final class SignInService: SignInServiceProtocol {
    // MARK: - Private static methods
    
    private static func isSignedIn(keychain: KeychainProtocol) -> Bool {
        keychain.rootURL != nil && keychain.apiKey != nil && keychain.cookie != nil
    }
    
    // MARK: - Private properties

    private var keychain: any KeychainProtocol

    private let networking: any SignInNetworkingProtocol

    private let cookieStorage: any CookieStorageProtocol
    
    private let pinStorage: any PinStorageProtocol
    
    private let feedStorage: any FeedStorageProtocol
    
    // MARK: - Public properties
    
    @Published private(set) var isSigningIn: Bool
    
    lazy var isSigningInPublisher: AnyPublisher<Bool, Never> = $isSigningIn.eraseToAnyPublisher()
    
    @Published private(set) var isSignedIn: Bool
    
    lazy var isSignedInPublisher: AnyPublisher<Bool, Never> = $isSignedIn.eraseToAnyPublisher()

    // MARK: - Init

    init(
        keychain: any KeychainProtocol,
        networking: any SignInNetworkingProtocol,
        cookieStorage: any CookieStorageProtocol,
        pinStorage: any PinStorageProtocol,
        feedStorage: any FeedStorageProtocol
    ) {
        self.keychain = keychain
        self.networking = networking
        self.cookieStorage = cookieStorage
        self.pinStorage = pinStorage
        self.feedStorage = feedStorage
        self.isSignedIn = Self.isSignedIn(keychain: keychain)
        self.isSigningIn = false
    }

    // MARK: - Public methods

    @MainActor
    func signIn(username: String, password: String) async throws {
        isSigningIn = true
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
            isSigningIn = false
            throw NetworkingError.noAuthenticityToken
        }

        // Call session endpoint with the "authenticity_token" and get apiKey from the response HTML
        let (sessionData, sessionResponse) = try await networking.session(
            username: username,
            password: password,
            authenticityToken: authenticityToken
        )
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
            .first
        guard let apiKey else {
            isSigningIn = false
            throw NetworkingError.noAPIKey
        }
        keychain.apiKey = apiKey
        cookieStorage.addCookies(urlResponse: sessionResponse)
        keychain.cookie = cookieStorage.cookieString(host: sessionResponse.url?.host)
        isSignedIn = Self.isSignedIn(keychain: keychain)
        isSigningIn = false
    }
    
    func signOut() {
        keychain.apiKey = nil
        keychain.cookie = nil
        pinStorage.set(pins: [])
        feedStorage.set(feeds: [])
        feedStorage.set(articleLists: [])
        isSignedIn = Self.isSignedIn(keychain: keychain)
        isSigningIn = false
    }

    func cancel() {
        networking.cancel()
        isSigningIn = false
    }
}
