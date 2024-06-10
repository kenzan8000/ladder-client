import Foundation

// MARK: - PinRowViewModel

@Observable
final class PinRowViewModel {
    // MARK: - Private properties
    
    private let pin: Pin
    
    // MARK: - Public properties
    
    var text: String { pin.title }
    
    var link: URL { pin.link }
    
    var isWebViewPresented = false
    
    // MARK: - Init
    
    init(pin: Pin) {
        self.pin = pin
    }
}
