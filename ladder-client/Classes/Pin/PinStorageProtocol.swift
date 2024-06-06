import Combine
import Foundation

protocol PinStorageProtocol {
    func set(pins: [Pin])
    
    func get() -> AnyPublisher<[Pin], Never>
}
