import SwiftUI
import SwiftyJSON
import WebKit

// MARK: - LDRFeedDetailWebViewModel
final class LDRFeedDetailWebViewModel: ObservableObject {
    
    // MARK: - model
    @Published var isLoadingWebView = true
    var webView = WKWebView()
    
    // MARK: - initialization

    // MARK: - destruction

    deinit {
    }

    // MARK: - access to the model

    // MARK: - intent
    
    // MARK: - notification
    
    // MARK: - public api
    
    /// load html string on webview
    /// - Parameters:
    ///   - colorScheme: color scheme like dark mode and light mode
    ///   - body: body string of HTML
    ///   - link: base url of RSS feeds
    func loadHTMLString(colorScheme: ColorScheme, body: String, link: URL) {
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
