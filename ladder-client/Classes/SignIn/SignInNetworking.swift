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

    // MARK: - Private methods

    @MainActor
    private func makeRequest(
        method: String,
        path: String,
        header: [String: String],
        queryItems: [URLQueryItem]? = nil,
        body: [String: Any]? = nil
    ) async throws -> URLRequest {
        guard let rootURL = keychain.rootURL,
        var components = URLComponents(url: rootURL, resolvingAgainstBaseURL: false) else {
            throw NetworkingError.invalidURL
        }
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else {
            throw NetworkingError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        request.allHTTPHeaderFields = header.merging(["Content-Length": "\(request.httpBody?.count ?? 0)"]) { _, new in new }
        return request
    }

    // MARK: - Public methods

    func signIn(username: String, password: String) async throws -> (Data, URLResponse) {
        let request = try await makeRequest(
            method: "GET",
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
        let request = try await makeRequest(
            method: "POST",
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
