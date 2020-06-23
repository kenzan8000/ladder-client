import SwiftUI
import SwiftyJSON

// MARK: - LDRFeedViewModel
final class LDRFeedViewModel: ObservableObject {
    
    // MARK: - model
    @Published var segment: Int
    @Published var subsunreads: [LDRFeedSubsUnread]
    @Published var isLoading = false
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
        segment = LDRFeedSubsUnread.Segment.rate
        subsunreads = LDRFeedSubsUnread.fetch(segment: LDRFeedSubsUnread.Segment.rate)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRFeedViewModel.didLogin),
            name: LDRNotificationCenter.didLogin,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRFeedViewModel.didBecomeActive),
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
            self.loadFeedFromAPI()
        }
    }
    
    /// called when did get unread
    ///
    /// - Parameter notification: notification happened when application did become active
    @objc
    func didBecomeActive(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.loadFeedFromAPI()
        }
    }
    
    // MARK: - public api
    
    /// Load Feed from local DB
    func loadFeedFromLocalDB() {
        subsunreads = LDRFeedSubsUnread.fetch(segment: segment)
    }
    
    /// Load Feed from API
    func loadFeedFromAPI() {
        if isLoading {
            return
        }
        isLoading = true
    }
}
