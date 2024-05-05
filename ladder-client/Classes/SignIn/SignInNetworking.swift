import Foundation

// MARK: - SignInNetworking

class SignInNetworking: SignInNetworkingProtocol {
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
            configuration: .background(withIdentifier: "org.kenzan8000.ladder-client.sign-in"),
            delegate: nil,
            delegateQueue: operationQueue
        )
    }()

    // MARK: - Init

    init(keychain: any KeychainProtocol) {
        self.keychain = keychain
    }

    // MARK: - Private methods

    private func makeRequest(
        method: String,
        path: String,
        header: [String: String],
        queryItems: [URLQueryItem]? = nil,
        body: [String: Any]? = nil
    ) throws -> URLRequest {
        guard let rootURL = keychain.rootURL,
        var components = URLComponents(url: rootURL, resolvingAgainstBaseURL: false) else {
            throw NetworkingError.invalidURL
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            throw NetworkingError.invalidURL
        }
        var request = URLRequest(url: url)
        let contentLength: Int
        if let body {
            let httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = httpBody
            contentLength = httpBody.count
        } else {
            contentLength = 0
        }
        request.httpMethod = method
        request.allHTTPHeaderFields = header.merging(["Content-Length": "\(contentLength)"]) { _, new in new }
        return request
    }

    // MARK: - Public methods

    func signIn(username: String, password: String) async throws -> (Data, URLResponse) {
        let request = try makeRequest(
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
        ]
        let request = try makeRequest(
            method: "POST",
            path: "/session",
            header: ["Content-Type": "application/json"],
            body: body
        )
        return try await urlSession.data(for: request)
    }

    func cancel() {
        urlSession.invalidateAndCancel()
        operationQueue.cancelAllOperations()
    }
}
