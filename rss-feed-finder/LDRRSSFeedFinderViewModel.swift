import Foundation
import UniformTypeIdentifiers

// MARK: - LDRRSSFeedFinderViewModel
struct LDRRSSFeedFinderViewModel {
    // MARK: property
    private let keychain: LDRKeychain
    private let urlSession: LDRSubscribeURLSession
    
    // MARK: initializer
    
    init(
        keychain: LDRKeychain,
        urlSession: LDRSubscribeURLSession = LDRDefaultSubscribeURLSession()
    ) {
        self.keychain = keychain
        self.urlSession = urlSession
    }
    
    // MARK: public api
    
    /// Find RSS feeds from app extension's contenxt
    /// - Parameter extensionContext: app extension's context. if it has URL, search RSS feeds on the URL.
    /// - Returns: `LDRGetSubscribeResponse` RSS feeds information
    func loadRSSFeeds(extensionContext: NSExtensionContext?) async throws -> LDRGetSubscribeResponse {
        guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            throw LDRError.others("") // TODO: add a new error for this
        }
        let itemProvider = inputItems
            .compactMap { $0.attachments }
            .flatMap { $0 }
            .filter { $0.hasItemConformingToTypeIdentifier(UTType.url.identifier) }
            .first
        let item = try await itemProvider?.loadItem(forTypeIdentifier: UTType.url.identifier)
        guard let url = item as? URL else {
            throw LDRError.others("") // TODO: add a new error for this
        }
        let (response, _) = try await urlSession.response(for: .getSubscribe(feedUrl: url, apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, cookie: keychain.cookie))
        return response
    }
}
