import SwiftUI
import SwiftyJSON

// MARK: - LDRPinViewModel
final class LDRPinViewModel: ObservableObject {
    
    // MARK: - model
    @Published var pins: [LDRPin]
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - initialization
    
    init() {
        pins = LDRPin.fetch()
    }

    // MARK: - access to the model

    // MARK: - intent
    
    // MARK: - public api

    func reload() {
        if isLoading {
            return
        }
        isLoading = true
        
        LDRPinOperationQueue.shared.requestPinAll { [unowned self] (json: JSON?, error: Error?) -> Void in
            if let error = error {
                self.error = error
            } else if let error = LDRPin.deleteAll() {
                self.error = error
            } else if let json = json, let error = LDRPin.save(json: json) {
                self.error = error
            } else {
                self.pins = LDRPin.fetch()
            }
            self.isLoading = false
        }
    }
}
