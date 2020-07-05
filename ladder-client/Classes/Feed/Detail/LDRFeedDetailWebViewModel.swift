import SwiftUI
import SwiftyJSON
import WebKit

// MARK: - LDRFeedDetailWebViewModel
final class LDRFeedDetailWebViewModel: ObservableObject {
    
    // MARK: - model
    var isInitialLoading = false
    @Published var doneInitialLoading = false
    var webView = WKWebView()
    var webViewNavigation = LDRFeedDetailWebViewNavigation()
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
    
    // MARK: - initialization
    
    init() {
        self.webView.isHidden = true
        webViewNavigation.didFinish = { [unowned self] _, _ in
            if self.isInitialLoading {
                return
            }
            self.isInitialLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [unowned self] in
                self.webView.isHidden = false
                self.doneInitialLoading = true
            }
            usleep(300000)
        }
        webViewNavigation.openUrl = { [unowned self] url in
            self.safariUrl = url
        }
        self.webView.navigationDelegate = webViewNavigation
    }

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

    // MARK: - LDRFeedDetailWebViewNavigation
    class LDRFeedDetailWebViewNavigation: NSObject, WKNavigationDelegate {

        var openUrl: ((_ url: URL) -> Void)?
        var didFinish: ((_ webView: WKWebView, _ navigation: WKNavigation) -> Void)?

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy
        ) -> Swift.Void) {
            switch navigationAction.navigationType {
            case .formSubmitted:
                break
            case .backForward:
                break
            case .reload:
                break
            case .formResubmitted:
                break
            case .other:
                break
            case .linkActivated:
                decisionHandler(.cancel)
                guard let url = navigationAction.request.url else {
                    decisionHandler(.cancel)
                    return
                }
                openUrl?(url)
                return
            @unknown default:
                return
            }
            decisionHandler(.allow)
        }

        func webView(
            _ webView: WKWebView,
            didFinish navigation: WKNavigation!
        ) {
            didFinish?(
                webView,
                navigation
            )
        }
    }
}
