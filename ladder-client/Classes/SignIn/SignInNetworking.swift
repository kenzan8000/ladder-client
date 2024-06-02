import Foundation

// MARK: - SignInNetworking

final class SignInNetworking: SignInNetworkingProtocol {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol

    private lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.name = "org.kenzan8000.ladder-client.sign-in-operation-queue"
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()

    private lazy var urlSession: URLSession = {
        URLSession(
            configuration: .default,
            delegate: nil,
            delegateQueue: operationQueue
        )
    }()

    // MARK: - Init

    init(keychain: any KeychainProtocol) {
        self.keychain = keychain
    }

    // MARK: - Public methods

    func signIn(username: String, password: String) async throws -> (Data, URLResponse) {
        let request = try URLRequest.networkingRequest(
            method: "GET",
            rootURL: keychain.rootURL,
            path: "/login",
            header: ["Content-Type": "text/html"],
            queryItems: [
                URLQueryItem(name: "username", value: username),
                URLQueryItem(name: "password", value: password),
            ]
        )
        return try await urlSession.data(for: request)
    }

    func session(username: String, password: String, authenticityToken: String) async throws -> (Data, URLResponse) {
        let body = [
            "username": username,
            "password": password,
            "authenticity_token": authenticityToken,
        ]
        let request = try URLRequest.networkingRequest(
            method: "POST",
            rootURL: keychain.rootURL,
            path: "/session",
            header: ["Content-Type": "application/json"],
            body: body
        )
        return try await urlSession.data(for: request)
    }

    func cancel() {
        operationQueue.cancelAllOperations()
    }
}
