import Foundation

// MARK: - PinListViewModel

@Observable
final class PinListViewModel {
    // MARK: - Private properties
    
    private let service: any PinServiceProtocol
    
    // MARK: - Public properties
    
    private(set) var pins: [Pin] = []
    
    // MARK: - Init
    
    init(service: any PinServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Public methods
    
    @MainActor
    func loadPins() async {
        guard !service.isGettingPins else {
            return
        }
        pins = (try? await service.getPins()) ?? []
    }
}
