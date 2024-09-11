import Combine
import Foundation

protocol PinStorageProtocol {
    func set(pins: [Pin])
    
    func add(pin: Pin)
    
    func remove(url: URL)
    
    func hasPin(url: URL?) -> Bool
    
    func get() -> AnyPublisher<[Pin], Never>
}
