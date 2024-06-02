import Combine
import Foundation

// MARK: - PinService

final class PinService: PinServiceProtocol {
    // MARK: - Private properties

    private var keychain: any KeychainProtocol

    private let networking: any PinNetworkingProtocol

    private let cookieStorage: any CookieStorageProtocol
    
    // MARK: - Public properties
    
    @Published private(set) var isGettingPins = false
    
    lazy var isGettingPinsPublisher: AnyPublisher<Bool, Never> = $isGettingPins.eraseToAnyPublisher()

    // MARK: - Init

    init(
        keychain: any KeychainProtocol,
        networking: any PinNetworkingProtocol,
        cookieStorage: any CookieStorageProtocol
    ) {
        self.keychain = keychain
        self.networking = networking
        self.cookieStorage = cookieStorage
    }

    // MARK: - Public methods

    @MainActor
    func getPins() async throws -> [Pin] {
        isGettingPins = true
        let (data, _) = try await networking.all()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Pin].self, from: data)
    }

    func cancel() {
        networking.cancel()
        isGettingPins = false
    }
}
