import SwiftUI
import SwiftyJSON

// MARK: - LDRFeedViewModel
final class LDRFeedViewModel: ObservableObject {
    
    // MARK: - model
    @Published var segment: Int
    @Published var subsunreads: [LDRFeedSubsUnread]
    @Published var rates: [String] = []
    @Published var folders: [String] = []
    var sections: [String] {
        segment == LDRFeedSubsUnread.Segment.rate ? rates : folders
    }
    @Published var unreads: [LDRFeedSubsUnread: LDRFeedUnread] = [:]
    @Published var unread: LDRFeedUnread?
    var isPresentingDetailView: Binding<Bool> {
        Binding<Bool>(
            get: { self.unread != nil },
            set: { newValue in
                guard !newValue else {
                    return
                }
                self.unread = nil
            }
        )
    }
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
        rates = LDRFeedSubsUnread.getRates(subsunreads: subsunreads)
        folders = LDRFeedSubsUnread.getFolders(subsunreads: subsunreads)
        
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
        DispatchQueue.main.async {
            self.loadFeedFromAPI()
        }
    }
    
    /// called when did get unread
    ///
    /// - Parameter notification: notification happened when application did become active
    @objc
    func didBecomeActive(notification: NSNotification) {
        DispatchQueue.main.async {
            self.loadFeedFromAPI()
        }
    }
    
    // MARK: - public api
    
    /// Load Feed from local DB
    func loadFeedFromLocalDB() {
        subsunreads = LDRFeedSubsUnread.fetch(segment: segment)
        rates = LDRFeedSubsUnread.getRates(subsunreads: subsunreads)
        folders = LDRFeedSubsUnread.getFolders(subsunreads: subsunreads)
    }
    
    /// Load Feed from API
    func loadFeedFromAPI() {
        if isLoading {
            return
        }
        isLoading = true
        LDRFeedOperationQueue.shared.requestSubs { (json: JSON?, error: Error?) -> Void in
            if let error = error {
                self.error = error
            } else if let error = LDRFeedSubsUnread.delete() {
                self.error = error
            } else if let json = json, let error = LDRFeedSubsUnread.save(json: json) {
                self.error = error
            } else {
                self.loadFeedFromLocalDB()
                self.loadUnreadsFromAPI()
            }
            self.isLoading = false
        }
    }
    
    func touchAll(unread: LDRFeedUnread) {
        if unread.state == LDRFeedUnread.State.unread {
            unread.requestTouchAll()
        }
    }
    
    /// Select LDRFeedUnread to focus
    /// - Parameter unread: LDRFeedUnread
    func selectUnread(unread: LDRFeedUnread) {
        self.unread = unread
    }
    
    /// Get subsuread models at section
    /// - Parameter section: one of rates or folders
    /// - Returns:subsuread models belonging to the section
    func getSubsUnreads(at section: String) -> [LDRFeedSubsUnread] {
        if segment == LDRFeedSubsUnread.Segment.rate {
            return LDRFeedSubsUnread.filter(subsunreads: subsunreads, rate: section)
        }
        return LDRFeedSubsUnread.filter(subsunreads: subsunreads, folder: section)
    }
    
    // MARK: - private api
    
    /// Load Unreads from API
    private func loadUnreadsFromAPI() {
        unreads = [:]
        for subsunread in self.subsunreads {
            let unread = LDRFeedUnread(subscribeId: subsunread.subscribeId, title: subsunread.title)
            unreads[subsunread] = unread
            unread.request()
        }
    }

}
