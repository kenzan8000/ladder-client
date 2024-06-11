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
    
    func get() -> AnyPublisher<[Pin], Never> {
        $pins.eraseToAnyPublisher()
    }
}
