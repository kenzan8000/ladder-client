import SwiftUI
import SwiftyJSON
import WebKit

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
    @Published var isLoadingWebView = true
    var webView = WKWebView()
    
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
    
    /// load html string on webview
    /// - Parameter colorScheme: color scheme like dark mode and light mode
    func loadHTMLString(colorScheme: ColorScheme) {
        let htmlBackgroundColor = colorScheme == .dark ? "background: #080808;" : "background: #f8f8f8;"
        let htmlColor = colorScheme == .dark ? "color: #E5E5EA;" : "color: #2c2c2e;"
        let htmlLinkColor = colorScheme == .dark ? "color: #0a84ff;" : "color: #007aff;"
        var html = "<html><style>"
        html += "html { width: 100% !important; \(htmlBackgroundColor) \(htmlColor) }"
        html += "body { font-family: -apple-system-ui-serif, ui-serif !important; font-size: 3.2em !important; max-width: 100% !important; padding: 1.0em !important; }"
        html += "a { \(htmlLinkColor) }"
        html += "html, body, div, span, applet, object, iframe, h1, h2, h3, h4, h5, h6, p, blockquote, pre, a, abbr, acronym, address, big,"
        html += "cite, code, del, dfn, em, img, ins, kbd, q, s, samp, small, strike, strong, sub, sup, tt, var, b, u, i, center, dl, dt, dd, ol, ul,"
        html += "li, fieldset, form, label, legend, table, caption, tbody, tfoot, thead, tr, th, td, article, aside, canvas, details, embed, figure,"
        html += "figcaption, footer, header, hgroup, menu, nav, output, ruby, section, summary, time, mark, audio, video"
        html += " { overflow-wrap: break-word !important; word-wrap: break-word !important; -webkit-hyphens: auto !important; -ms-hyphens: auto !important; -moz-hyphens: auto !important; hyphens: auto !important; max-width: 100% !important; }"
        html += "</style><body>"
        html += body
        html += "</body></html>"
        webView.loadHTMLString(html, baseURL: link)
    }
    
    // MARK: - private api

}
