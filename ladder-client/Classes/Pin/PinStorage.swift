import Combine
import Foundation

final class PinStorage: PinStorageProtocol {
    // MARK: - Private properties
    
    @Published private var pins: [Pin] = []
    
    // MARK: - Public methods
    
    @MainActor
    func set(pins: [Pin]) {
        self.pins = pins
    }
    
    @MainActor
    func add(pin: Pin) {
        pins.append(pin)
    }
    
    @MainActor
    func hasPin(url: URL?) -> Bool {
        pins.contains { (pin: Pin) in pin.link == url }
    }

    func get() -> AnyPublisher<[Pin], Never> {
        $pins.eraseToAnyPublisher()
    }
}
