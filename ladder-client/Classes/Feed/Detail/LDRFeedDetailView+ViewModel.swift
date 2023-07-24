import Combine
import SwiftUI
import WebKit

// MARK: - LDRFeedDetailView + ViewModel
extension LDRFeedDetailView {
    // MARK: ViewModel
    class ViewModel: ObservableObject {
            
        // MARK: property
        let storageProvider: LDRStorageProvider
        let keychain: LDRKeychain
        private let urlSession: LDRURLSession
        @Published var subsunread: LDRFeedSubsUnread
        let onAlertDismiss: () -> Void
        @Published var index = 0
        let unreads: [LDRFeedUnread]
        var unread: LDRFeedUnread? { unreads[index] }
        var count: Int { unreads.count }
        var title: String { unread?.title ?? "" }
        var body: String { unread?.body ?? "" }
        var link: URL { unread?.linkUrl ?? URL(fileURLWithPath: "") }
        var prevTitle: String { index > 0 ? unreads[index - 1].title : "" }
        var nextTitle: String { index + 1 < unreads.count ? unreads[index + 1].title : "" }
        @Published var alertToShow: Alert.ViewModel?
        private var pinAddCancellables = Set<AnyCancellable>()
        private var notificationCancellables = Set<AnyCancellable>()

        // MARK: initializer
        
        /// Inits
        /// - Parameters:
        ///     - storageProvider: for CoreData
        ///     - keychain: LDRKeychain
        ///     - subsunread: LDRFeedSubsUnread model
        ///     - onAlertDismiss: @escaping () -> Void     
        init(
            storageProvider: LDRStorageProvider,
            keychain: LDRKeychain,
            subsunread: LDRFeedSubsUnread,
            onAlertDismiss: @escaping () -> Void = {}
        ) {
            self.storageProvider = storageProvider
            self.keychain = keychain
            self.subsunread = subsunread
            self.onAlertDismiss = onAlertDismiss
            urlSession = LDRDefaultURLSession(keychain: keychain)
            unreads = subsunread.unreads.sorted { $0.id < $1.id }
            NotificationCenter.default.publisher(for: .ldrDidLogin)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.pinAddCancellables.forEach { $0.cancel() }
                }
                .store(in: &notificationCancellables)
        }

        // MARK: public api
            
        /// Update unread index to next or previous unread
        /// - Parameter val: val to add
        /// - Returns: Bool if you can move
        func addIndex(_ val: Int) -> Bool {
            index += val
            if index < 0 {
                index = 0
                return false
            } else if index >= count {
                index = count - 1
                return false
            }
            return true
        }

        /// Saves a pin
        func savePin() {
            guard let unread else {
                return
            }
            if storageProvider.existPin(link: unread.link) {
                return
            }
            storageProvider.savePin(title: unread.title, link: unread.link)
            urlSession.publisher(for: .pinAdd(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, title: unread.title, link: unread.linkUrl, cookie: keychain.cookie), using: .init())
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] result in
                        if case let .failure(error) = result, let self = self {
                            self.alertToShow = .init(title: "", message: error.legibleDescription, buttonText: "OK", buttonAction: self.onAlertDismiss)
                        }
                    },
                    receiveValue: { [weak self] response in
                        if !response.isSuccess, let self = self {
                            self.alertToShow = .init(title: "", message: "Failed to add a pin. (\(unread.link))", buttonText: "OK", buttonAction: self.onAlertDismiss)
                        }
                    }
                )
                .store(in: &pinAddCancellables)
        }
    }
}
