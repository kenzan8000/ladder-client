import SwiftUI
import SwiftyJSON

// MARK: - LDRPinViewModel
final class LDRPinViewModel: ObservableObject {
    
    // MARK: - model
    @Published var pins: [LDRPin]
    @Published var isLoading = false
    @Published var safariUrl: URL?
    var isPresentingSafariView: Binding<Bool> {
        Binding<Bool>(
            get: { self.safariUrl != nil },
            set: { newValue in
                guard !newValue else {
                    return
                }
                self.safariUrl = nil
            }
        )
    }
    @Published var error: Error?
    var isPresentingAlert: Binding<Bool> {
        Binding<Bool>(
            get: { self.error != nil },
            set: { newValue in
                guard !newValue else {
                    return
                }
                self.error = nil
            }
        )
    }
    
    // MARK: - initialization
    
    init() {
        pins = LDRPin.fetch()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRPinViewModel.didLogin),
            name: LDRNotificationCenter.didLogin,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRPinViewModel.didBecomeActive),
            name: LDRNotificationCenter.didBecomeActive,
            object: nil
        )
    }

    // MARK: - destruction

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - access to the model

    // MARK: - intent
    
    // MARK: - notification
    
    /// called when user did login
    ///
    /// - Parameter notification: NSNotification happened when user did login
    @objc
    func didLogin(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.loadPinsFromAPI()
        }
    }
    
    /// called when did get unread
    ///
    /// - Parameter notification: notification happened when application did become active
    @objc
    func didBecomeActive(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.loadPinsFromAPI()
        }
    }
    
    // MARK: - public api
    
    func loadPinsFromLocalDB() {
        pins = LDRPin.fetch()
    }
    
    func loadPinsFromAPI() {
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
    
    func delete(pin: LDRPin) {
        if let url = pin.linkUrl {
            self.safariUrl = url
            LDRPinOperationQueue.shared.requestPinRemove(link: url) { _, _ in }
        }
        if let error = LDRPin.delete(pin: pin) {
            self.error = error
            return
        }
        pins = LDRPin.fetch()
    }
}
