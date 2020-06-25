import SwiftUI
import SwiftyJSON

// MARK: - LDRFeedDetailViewModel
final class LDRFeedDetailViewModel: ObservableObject {
    
    // MARK: - model
    @Published var unread: LDRFeedUnread
    
    // MARK: - initialization
    
    init(unread: LDRFeedUnread) {
        self.unread = unread
    }

    // MARK: - destruction

    deinit {
    }

    // MARK: - access to the model

    // MARK: - intent
    
    // MARK: - notification
    
    // MARK: - public api
    
    // MARK: - private api

}
