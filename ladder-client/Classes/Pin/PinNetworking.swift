import Foundation

// MARK: - PinNetworking

final class PinNetworking: PinNetworkingProtocol {
    // MARK: - Private properties

    private let keychain: any KeychainProtocol

    private lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.name = "org.kenzan8000.ladder-client.pin-operation-queue"
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
    
    func all() async throws -> (Data, URLResponse) {
        let request = try URLRequest.networkingRequest(
            method: "POST",
            rootURL: keychain.rootURL,
            path: "/api/pin/all",
            header: [
                "Content-Type": "application/json",
                "Cookie": keychain.cookie ?? "",
            ],
            body: ["ApiKey": keychain.apiKey ?? ""]
        )
        return try await urlSession.data(for: request)
    }

    func cancel() {
        operationQueue.cancelAllOperations()
    }
}
