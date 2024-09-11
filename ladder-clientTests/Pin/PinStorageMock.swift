import Combine
import Foundation
@testable import ladder_client

// MARK: - PinStorageMock

final class PinStorageMock: PinStorageProtocol {
    @Published var pins = [Pin]()
    
    @MainActor
    func set(pins: [Pin]) {
        self.pins = pins
    }
    
    @MainActor
    func add(pin: Pin) {
        pins.append(pin)
    }

    @MainActor
    func remove(url: URL) {
        pins = pins.filter { (pin: Pin) in pin.link != url }
    }

    @MainActor
    func hasPin(url: URL?) -> Bool {
        pins.contains { (pin: Pin) in pin.link == url }
    }
    
    func get() -> AnyPublisher<[Pin], Never> {
        $pins.eraseToAnyPublisher()
    }
}
