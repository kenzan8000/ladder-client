import Foundation

// MARK: - PinRowViewModel

@Observable
final class PinRowViewModel {
    // MARK: - Private properties
    
    private let pin: Pin
    
    // MARK: - Public properties
    
    var title: String { pin.title }
    
    // MARK: - Init
    
    init(pin: Pin) {
        self.pin = pin
    }
}
