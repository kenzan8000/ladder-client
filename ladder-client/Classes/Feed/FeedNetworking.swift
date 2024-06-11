import Foundation

// MARK: - FeedNetworking

final class FeedNetworking: FeedNetworkingProtocol {
    
    // MARK: - Private properties
    
    private let keychain: any KeychainProtocol
    
    private lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        operationQueue.name = "org.kenzan8000.ladder-client.feed-operation-queue"
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

    func feeds() async throws -> (Data, URLResponse) {
        let request = try URLRequest.networkingRequest(
            method: "POST",
            rootURL: keychain.rootURL,
            path: "/api/subs",
            header: [
                "Content-Type": "application/json",
                "Cookie": keychain.cookie ?? "",
            ],
            queryItems: [URLQueryItem(name: "unread", value: "1")],
            body: ["ApiKey": keychain.apiKey ?? ""]
        )
        return try await urlSession.data(for: request)
    }
    
    func unreadArticles(feedId: Int) async throws -> (Data, URLResponse) {
        let request = try URLRequest.networkingRequest(
            method: "POST",
            rootURL: keychain.rootURL,
            path: "/api/unread",
            header: [
                "Content-Type": "application/json",
                "Cookie": keychain.cookie ?? "",
            ],
            body: [
                "ApiKey": keychain.apiKey ?? "",
                "subscribe_id": "\(feedId)"
            ]
        )
        return try await urlSession.data(for: request)
    }
    
    func removeUnreadArticles(feedId: Int) async throws -> (Data, URLResponse) {
        let request = try URLRequest.networkingRequest(
            method: "POST",
            rootURL: keychain.rootURL,
            path: "/api/touch_all",
            header: [
                "Content-Type": "application/json",
                "Cookie": keychain.cookie ?? "",
            ],
            body: [
                "ApiKey": keychain.apiKey ?? "",
                "subscribe_id": "\(feedId)"
            ]
        )
        return try await urlSession.data(for: request)
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}
