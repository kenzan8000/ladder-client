import Foundation
import HTMLReader

// MARK: - LDRRequest + RSSFolder
extension LDRRequest where Response == LDRGetSubscribeResponse {
    // MARK: static api
    
    /// Request checking if the URL has the RSS feeds
    /// - Parameters:
    ///     - feedURL: RSS feed `URL`
    ///     - apiKey: apiKey string
    ///     - ldrUrlString: domain + url path (optional) that runs fastladder app
    ///     - cookie: cookie string
    /// - Returns: `LDRRequest`
    static func getSubscribe(
        feedUrl: URL,
        apiKey: String?,
        ldrUrlString: String?,
        cookie: String?
    ) -> Self {
        let url = URL(ldrUrlString: ldrUrlString, ldrPath: LDRApi.subscribe)
        let queryItems = [URLQueryItem(name: "url", value: feedUrl.absoluteString)]
        return LDRRequest(
            url: url,
            method: .get(queryItems),
            headers: .defaultHTMLHeader(cookie: cookie)
        )
    }
}

// MARK: - LDRGetSubscribeResponse
struct LDRGetSubscribeResponse: Codable, Equatable {
    // MARK: property
    
    /// RSS feeds to subscribe
    let feeds: [LDRRSSFeed]
    
    /// available folders to assign to RSS feed
    let folders: [LDRRSSFolder]
    
    /// available ratings for RSS feed
    let rates: [LDRRSSRate]
}

// MARK: - LDRRSSFeed
struct LDRRSSFeed: Codable, Equatable {
    // MARK: property
    
    /// RSS feed id if the feed is already subscribed
    let id: UInt?
    
    /// RSS feed title
    let title: String
    
    /// RSS feed URL
    let url: URL
    
    /// flag if RSS feed is already subscribed
    var isSubscribed: Bool { id != nil }
}

// MARK: - LDRRSSFolder
struct LDRRSSFolder: Codable, Equatable {
    // MARK: property
    let id: UInt
    let name: String
}

// MARK: - LDRRSSRate
struct LDRRSSRate: Codable, Equatable {
    // MARK: property
    let value: UInt
}

// MARK: - LDRSubscribeURLSession
protocol LDRSubscribeURLSession {
    func response(
        for request: LDRRequest<LDRGetSubscribeResponse>
    ) async throws -> (LDRGetSubscribeResponse, URLResponse)
}

// MARK: - LDRDefaultSubscribeURLSession
class LDRDefaultSubscribeURLSession: LDRSubscribeURLSession {
    // MARK: property
    
    let urlSession: URLSessionProtocol
    
    // MARK: initializer
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: public api
    
    func response(
        for request: LDRRequest<LDRGetSubscribeResponse>
    ) async throws -> (LDRGetSubscribeResponse, URLResponse) {
        let (data, urlResponse) = try await urlSession.data(for: request.urlRequest)
        let html = HTMLDocument(data: data, contentTypeHeader: "text/html")
        let feeds = try getFeeds(html: html)
        let folders = getFolders(html: html)
        let rates = getRates(html: html)
        return (LDRGetSubscribeResponse(feeds: feeds, folders: folders, rates: rates), urlResponse)
    }
    
    // MARK: private api
    
    private func getFeeds(html: HTMLDocument) throws -> [LDRRSSFeed] {
        guard let feedCandidates = html.nodes(matchingSelector: "ul").first(where: { (element: HTMLElement) in
            element.attributes.contains { $0.key == "id" && $0.value == "feed_candidates" }
        }) else {
            throw LDRError.rssFeedNotFound
        }
        let feeds = feedCandidates.nodes(matchingSelector: "li")
            .compactMap { (element: HTMLElement) -> LDRRSSFeed? in
                let subsDeleteButton = element.nodes(matchingSelector: "button")
                    .first { button in button.attributes.contains { $0.key == "class" && $0.value == "subs_delete" } }
                let id = subsDeleteButton?.attributes
                    .first { $0.key == "id" && $0.value.hasPrefix("sub_") }
                    .map { UInt(String($0.value.dropFirst("sub_".count))) } as? UInt
                let subscribeList = element.nodes(matchingSelector: "a")
                    .first { a in a.attributes.contains { $0.key == "class" && $0.value == "subscribe_list" } }
                let title = subscribeList?.textContent
                let feedlink = element.nodes(matchingSelector: "a")
                    .first { a in a.attributes.contains { $0.key == "class" && $0.value == "feedlink" } }
                let url = feedlink?.attributes
                    .first { $0.key == "href" }
                    .map { URL(string: $0.value) } as? URL
                guard let title, let url else {
                    return nil
                }
                return LDRRSSFeed(id: id, title: title, url: url)
            }
        if feeds.isEmpty {
            throw LDRError.rssFeedNotFound
        }
        return feeds
    }
    
    private func getFolders(html: HTMLDocument) -> [LDRRSSFolder] {
        let folderSelect = html.nodes(matchingSelector: "select")
            .first { (element: HTMLElement) in
                element.attributes.contains { $0.key == "id" && $0.value == "folder_id" }
            }
        return folderSelect?.nodes(matchingSelector: "option")
            .compactMap { (element: HTMLElement) -> LDRRSSFolder? in
                let id = element.attributes
                    .first { $0.key == "value" }
                    .map { UInt($0.value) }
                let name = element.textContent
                guard let id, let id else {
                    return nil
                }
                return LDRRSSFolder(id: id, name: name)
            } ?? []
    }
    
    private func getRates(html: HTMLDocument) -> [LDRRSSRate] {
        let folderSelect = html.nodes(matchingSelector: "select")
            .first { (element: HTMLElement) in
                element.attributes.contains { $0.key == "name" && $0.value == "rate" }
            }
        return folderSelect?.nodes(matchingSelector: "option")
            .compactMap { (element: HTMLElement) -> LDRRSSRate? in
                let value = element.attributes
                    .first { $0.key == "value" }
                    .map { UInt($0.value) }
                guard let value, let value else {
                    return nil
                }
                return LDRRSSRate(value: value)
            } ?? []
    }
}
