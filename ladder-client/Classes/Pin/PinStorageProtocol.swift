import Combine
import Foundation

protocol PinStorageProtocol {
    func set(pins: [Pin])
    
    func add(pin: Pin)
    
    func get() -> AnyPublisher<[Pin], Never>
}
