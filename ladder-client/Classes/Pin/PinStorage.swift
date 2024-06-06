import Combine
import Foundation

final class PinStorage: PinStorageProtocol {
    // MARK: - Private properties
    
    @Published private var pins: [Pin] = []
    
    // MARK: - Public methods
    
    func set(pins: [Pin]) {
        self.pins = pins
    }
    
    func get() -> AnyPublisher<[Pin], Never> {
        $pins.eraseToAnyPublisher()
    }
}
