import KSToastView
import SafariServices
import SwiftyJSON
import UIKit
import WebKit

// MARK: - LDRFeedDetailViewController
class LDRFeedDetailViewController: UIViewController {

    // MARK: - properties

    @IBOutlet private weak var detailView: UIView!

    @IBOutlet private weak var headerButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var webViewActivityIndicatorView: UIActivityIndicatorView!
    var webViewDidFinishNavigation = false
    
    var titleLabel: UILabel!
    
    var unread: LDRFeedUnread?
    var index = 0
    
    var htmlBackgroundColor = ""
    var htmlColor = ""
    var htmlLinkColor = ""
    
    // MARK: - class method
    
    /// returns view controller object
    ///
    /// - Returns: view controller object
    class func ldr_viewController() -> LDRFeedDetailViewController? {
        let vc = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: LDRNSStringFromClass(LDRFeedDetailViewController.self)
        ) as? LDRFeedDetailViewController
        return vc
    }

    // MARK: - life cycle

    override func loadView() {
        super.loadView()

        self.htmlBackgroundColor = self.traitCollection.userInterfaceStyle == .dark ? "background: #333;" : "background: #e5e5eaff;"
        self.htmlColor = self.traitCollection.userInterfaceStyle == .dark ? "color: #E5E5EA;" : "color: #2c2c2e;"
        self.htmlLinkColor = self.traitCollection.userInterfaceStyle == .dark ? "color: #0a84ff;" : "color: #007aff;"
        
        self.webView.navigationDelegate = self

        self.initNavigationBar()
        
        // back and next button
        self.backButton.setImage(
            IonIcons.image(
                withIcon: ion_chevron_left,
                iconColor: UIColor.label,
                iconSize: 36,
                imageSize: CGSize(width: 36, height: 36)
            ),
            for: .normal
        )
        self.nextButton.setImage(
            IonIcons.image(
                withIcon: ion_chevron_right,
                iconColor: UIColor.label,
                iconSize: 36,
                imageSize: CGSize(width: 36, height: 36)
            ),
            for: .normal
        )
        
        self.loadUnreadItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.titleLabel = nil
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.detailView.frame = CGRect(
            x: 0,
            y: self.view.safeAreaInsets.top,
            width: self.detailView.frame.width,
            height: self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.titleLabel.textColor = UIColor(named: "Text1")
        self.loadUnreadItem()
    }

    // MARK: - event listener
    
    /// Descalled when touched up insidecription
    ///
    /// - Parameter barButtonItem: UIBarButtonItem for the event
    @objc
    func barButtonItemTouchedUpInside(barButtonItem: UIBarButtonItem) {
        if barButtonItem == self.navigationItem.leftBarButtonItem {
            self.navigationController?.popViewController(animated: true)
        } else if barButtonItem == self.navigationItem.rightBarButtonItem {
            guard let unreadItem = self.unread else {
                return
            }
            guard let title = unreadItem.getTitle(at: self.index),
                let link = unreadItem.getLink(at: self.index) else {
                return
            }

            KSToastView.ks_showToast("Added a pin\n\(title)", duration: 2.0)

            if !(LDRPin.alreadySavedPin(link: link.absoluteString, title: title)) {
                let error = LDRPin.saveByAttributes(createdOn: "", title: title, link: link.absoluteString)
                if error == nil {
                    LDRPinOperationQueue.shared.requestPinAdd(
                        link: link,
                        title: title,
                        completionHandler: { _, _ in }
                    )
                }
            }
        }
    }
    
    /// called when touched up inside
    ///
    /// - Parameter button: UIButton for the event
    @IBAction private func buttonTouchedUpInside(button: UIButton) {
        if button == self.headerButton {
            guard let unreadItem = self.unread else {
                return
            }
            if self.index < 0 {
                return
            }
            if self.index >= unreadItem.items.count {
                return
            }

            // browser
            if let url = unreadItem.getLink(at: self.index) {
                self.presentSafari(url: url)
            }
        }
        if button == self.backButton {
            if !(self.addIndexIfPossible(value: -1)) {
                LDRBlinkView.show(
                    on: UIApplication.shared.windows[0],
                    color: UIColor.systemGray6.withAlphaComponent(0.5),
                    count: 1,
                    interval: 0.08
                )
            } else { self.loadUnreadItem() }

        }
        if button == self.nextButton {
            if !(self.addIndexIfPossible(value: 1)) {
                LDRBlinkView.show(
                    on: UIApplication.shared.windows[0],
                    color: UIColor.systemGray6.withAlphaComponent(0.5),
                    count: 1,
                    interval: 0.08
                )
            } else { self.loadUnreadItem() }
        }
    }

    // MARK: - public api

    /// present safari view controller
    ///
    /// - Parameter url: url opened on safari view controller
    func presentSafari(url: URL) {
        let viewController = SFSafariViewController(url: url)
        viewController.hidesBottomBarWhenPushed = true
        viewController.dismissButtonStyle = .close
        self.present(
            viewController,
            animated: true,
            completion: nil
        )
    }

    /// load unread item as static html on the view
    func loadUnreadItem() {
        guard let unreadItem = self.unread else {
            return
        }

        self.backButton.alpha = (self.index != 0) ? 1.0 : 0.5
        self.nextButton.alpha = (self.index < unreadItem.items.count - 1) ? 1.0 : 0.5

        self.titleLabel.text = unreadItem.getTitle(at: self.index)

        self.headerButton.setTitle("\(self.index + 1) / \(unreadItem.items.count)", for: .normal)
        
        var html = "<html><style>"
        html += "html { width: 100% !important; \(self.htmlBackgroundColor) \(self.htmlColor) }"
        html += "body { font-family: -apple-system-ui-serif, ui-serif !important; font-size: 3.2em !important; max-width: 100% !important; padding: 1.0em !important; }"
        html += "a { \(self.htmlLinkColor) }"
        html += "html, body, div, span, applet, object, iframe, h1, h2, h3, h4, h5, h6, p, blockquote, pre, a, abbr, acronym, address, big,"
        html += "cite, code, del, dfn, em, img, ins, kbd, q, s, samp, small, strike, strong, sub, sup, tt, var, b, u, i, center, dl, dt, dd, ol, ul,"
        html += "li, fieldset, form, label, legend, table, caption, tbody, tfoot, thead, tr, th, td, article, aside, canvas, details, embed, figure,"
        html += "figcaption, footer, header, hgroup, menu, nav, output, ruby, section, summary, time, mark, audio, video"
        html += " { overflow-wrap: break-word !important; word-wrap: break-word !important; -webkit-hyphens: auto !important; -ms-hyphens: auto !important; -moz-hyphens: auto !important; hyphens: auto !important; max-width: 100% !important; }"
        html += "</style><body>"

        if let body = unreadItem.getBody(at: self.index) {
            html += "\(body)"
        }
        html += "</body></html>"
        let link = unreadItem.getLink(at: self.index)
        self.webView.loadHTMLString(html, baseURL: link)
    }

    /// add the value to current index
    ///
    /// - Parameter value: value (-1: previous page or 1: next page)
    /// - Returns: true if the result index is valid, no if not valid
    func addIndexIfPossible(value: Int) -> Bool {
        guard let unreadItem = self.unread else {
            return false
        }

        let newValue = self.index + value
        if newValue < 0 {
            return false
        }
        if newValue >= unreadItem.items.count {
            return false
        }
        self.index = newValue
        return true
    }
    
    // MARK: - public api
    
    /// Initialize Navigation Bar
    private func initNavigationBar() {
        // bar button items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(
                withIcon: ion_chevron_left,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(
                withIcon: ion_pin,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )

        if let nvc = self.navigationController,
            let leftBarButtonItem = self.navigationItem.leftBarButtonItem,
            let leftBarButtonItemImage = leftBarButtonItem.image {
            let w = (nvc.navigationBar.frame.width) - 2.0 * leftBarButtonItemImage.size.width
            let h = nvc.navigationBar.frame.height
            let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: w, height: h))
            let label = UILabel(frame: frame)
            label.numberOfLines = 3
            label.lineBreakMode = .byWordWrapping
            label.textColor = UIColor(named: "Text1")
            label.font = label.font.withSize(12)
            self.titleLabel = label
            self.navigationItem.titleView = label
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension LDRFeedDetailViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }

}

// MARK: - WKNavigationDelegate
extension LDRFeedDetailViewController: WKNavigationDelegate {
    
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
            self.presentSafari(url: url)
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
        if self.webViewDidFinishNavigation {
            return
        }
        self.webViewDidFinishNavigation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [unowned self] in
            self.webViewActivityIndicatorView.isHidden = true
            self.webView.isHidden = false
        }
        usleep(300000)
    }
}
