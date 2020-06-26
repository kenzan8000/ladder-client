import SwiftUI
import SwiftyJSON

// MARK: - LDRFeedDetailViewModel
final class LDRFeedDetailViewModel: ObservableObject {
    
    // MARK: - model
    @Published var unread: LDRFeedUnread
    @Published var index: Int = 0
    var count: Int {
        unread.items.count
    }
    var title: String {
        guard let title = unread.getTitle(at: index) else {
            return ""
        }
        return title
    }
    var body: String {
        guard let body = unread.getBody(at: index) else {
            return ""
        }
        return body
    }
    var link: URL {
        guard let link = unread.getLink(at: index) else {
            return URL(fileURLWithPath: "")
        }
        return link
    }
    var prevTitle: String {
        guard let title = unread.getTitle(at: index - 1) else {
            return ""
        }
        return title
    }
    var nextTitle: String {
        guard let title = unread.getTitle(at: index + 1) else {
            return ""
        }
        return title
    }
    
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
    
    /// Update unread index to next or previous unread
    /// - Parameter offset: offset to move 1 or -1
    /// - Returns: Bool if you can move
    func move(offset: Int) -> Bool {
        index += offset
        if index < 0 {
            index = 0
            return false
        } else if index >= count {
            index = count - 1
            return false
        }
        return true
    }

    /// Save pin you currently focus on
    /// - Returns: Bool if you could save the current focusing pin on local DB
    func savePin() -> Bool {
        if !LDRPin.alreadySavedPin(link: link.absoluteString, title: title) {
            if LDRPin.saveByAttributes(createdOn: "", title: title, link: link.absoluteString) != nil {
                return false
            }
            LDRPinOperationQueue.shared.requestPinAdd(
                link: link,
                title: title
            ) { _, _ in }
        }
        return true
    }
    
    // MARK: - private api

}
