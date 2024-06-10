import Combine
import Foundation

// MARK: - PinService

final class PinService: PinServiceProtocol {
    // MARK: - Private properties

    private var keychain: any KeychainProtocol

    private let networking: any PinNetworkingProtocol
    
    private let pinStorage: any PinStorageProtocol

    private let cookieStorage: any CookieStorageProtocol
    
    // MARK: - Public properties
    
    @Published private(set) var isGettingPins = false
    
    lazy var isGettingPinsPublisher: AnyPublisher<Bool, Never> = $isGettingPins.eraseToAnyPublisher()

    var isLoading: Bool { isGettingPins }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> { isGettingPinsPublisher }

    // MARK: - Init

    init(
        keychain: any KeychainProtocol,
        networking: any PinNetworkingProtocol,
        pinStorage: any PinStorageProtocol,
        cookieStorage: any CookieStorageProtocol
    ) {
        self.keychain = keychain
        self.networking = networking
        self.pinStorage = pinStorage
        self.cookieStorage = cookieStorage
    }

    // MARK: - Public methods

    @MainActor
    func loadPins() async {
        isGettingPins = true
        do {
            let (data, _) = try await networking.all()
            let pins = try JSONDecoder().decode([Pin].self, from: data)
            pinStorage.set(pins: pins)
        } catch {
            isGettingPins = false
            pinStorage.set(pins: [])
            return
        }
        isGettingPins = false
    }
    
    @MainActor
    func addPin(title: String, link: URL) async -> Bool {
        guard let (data, _) = try? await networking.add(title: title, link: link),
        let response = try? JSONDecoder().decode(NetworkingResponse.self, from: data) else {
            return false
        }
        return response.isSucceeeded
    }
    
    @MainActor
    func removePin(link: URL) async -> Bool {
        guard let (data, _) = try? await networking.remove(link: link),
        let response = try? JSONDecoder().decode(NetworkingResponse.self, from: data) else {
            return false
        }
        return response.isSucceeeded
    }

    @MainActor
    func cancel() {
        networking.cancel()
        isGettingPins = false
    }
    
    @MainActor
    func reload() {
        cancel()
        Task { @MainActor in
            await loadPins()
        }
    }
}
