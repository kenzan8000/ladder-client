import Combine
import Foundation

protocol PinStorageProtocol {
    func set(pins: [Pin])
    
    func add(pin: Pin)
    
    func hasPin(url: URL?) -> Bool
    
    func get() -> AnyPublisher<[Pin], Never>
}
