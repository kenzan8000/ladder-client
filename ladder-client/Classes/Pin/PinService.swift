import Combine
import Foundation

// MARK: - PinService

final class PinService: PinServiceProtocol {
    // MARK: - Private properties

    private let networking: any PinNetworkingProtocol
    
    private let storage: any PinStorageProtocol
    
    // MARK: - Public properties
    
    @Published private(set) var isLoading = false
    
    lazy var isLoadingPublisher: AnyPublisher<Bool, Never> = $isLoading.eraseToAnyPublisher()

    // MARK: - Init

    init(
        networking: any PinNetworkingProtocol,
        storage: any PinStorageProtocol
    ) {
        self.networking = networking
        self.storage = storage
    }

    // MARK: - Public methods

    @MainActor
    func loadPins() async {
        isLoading = true
        do {
            let (data, _) = try await networking.pins()
            let pins = try JSONDecoder().decode([Pin].self, from: data)
            storage.set(pins: pins)
        } catch {
            isLoading = false
            storage.set(pins: [])
            return
        }
        isLoading = false
    }
    
    func addPin(title: String, link: URL) async -> Bool {
        guard let (data, _) = try? await networking.addPin(title: title, link: link),
        let response = try? JSONDecoder().decode(NetworkingResponse.self, from: data) else {
            return false
        }
        storage.add(pin: Pin(createdAt: Date(), link: link, title: title))
        return response.isSucceeeded
    }
    
    func removePin(link: URL) async -> Bool {
        guard let (data, _) = try? await networking.removePin(link: link),
        let response = try? JSONDecoder().decode(NetworkingResponse.self, from: data) else {
            return false
        }
        storage.remove(url: link)
        return response.isSucceeeded
    }

    @MainActor
    func cancel() {
        networking.cancel()
        isLoading = false
    }
    
    @MainActor
    func reload() {
        cancel()
        Task { @MainActor in
            await loadPins()
        }
    }
}
