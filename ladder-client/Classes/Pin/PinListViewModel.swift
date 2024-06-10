import Combine
import Foundation

// MARK: - PinListViewModel

@Observable
final class PinListViewModel {
    // MARK: - Private properties
    
    private let service: any PinServiceProtocol
    
    private let storage: any PinStorageProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    
    private(set) var pins: [Pin] = []
    
    // MARK: - Init
    
    init(
        service: any PinServiceProtocol,
        storage: any PinStorageProtocol
    ) {
        self.service = service
        self.storage = storage
        storage.get()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (pins: [Pin]) in self?.pins = pins }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Public methods
    
    @MainActor
    func loadPins() async {
        guard !service.isGettingPins else {
            return
        }
        await service.loadPins()
    }
}
