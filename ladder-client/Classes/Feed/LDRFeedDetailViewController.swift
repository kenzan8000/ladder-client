import KSToastView
import SafariServices
import SwiftyJSON
import UIKit
import WebKit


/// MARK: - LDRFeedDetailViewController
class LDRFeedDetailViewController: UIViewController {

    // MARK: - properties

    @IBOutlet weak var detailView: UIView!

    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    var titleLabel: UILabel!
    
    var unread: LDRFeedUnread?
    var index = 0


    /// MARK: - class method

    /**
     * get viewController
     * @return LDRFeedDetailViewController
     **/
    class func ldr_viewController() -> LDRFeedDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LDRNSStringFromClass(LDRFeedDetailViewController.self)) as! LDRFeedDetailViewController
        return vc
    }


    // MARK: - life cycle

    override func loadView() {
        super.loadView()

        self.webView.navigationDelegate = self

        // bar button items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_arrow_left, iconColor: UIColor.systemGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_pin, iconColor: UIColor.systemGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )
        // back and next button
        self.backButton.setImage(IonIcons.image(withIcon: ion_ios_arrow_left, iconColor: UIColor.systemGray, iconSize: 36, imageSize: CGSize(width: 36, height: 36)), for: .normal)
        self.nextButton.setImage(IonIcons.image(withIcon: ion_ios_arrow_right, iconColor: UIColor.systemGray, iconSize: 36, imageSize: CGSize(width: 36, height: 36)), for: .normal)

        let w = (self.navigationController?.navigationBar.frame.width)! - 2.0*(self.navigationItem.leftBarButtonItem?.image?.size.width)!
        let h = (self.navigationController?.navigationBar.frame.height)!
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: w, height: h)))
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor(named: "Text1")
        label.font = label.font.withSize(12)
        self.titleLabel = label
        self.navigationItem.titleView = label
        
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
        self.detailView.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.detailView.frame.width, height: self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.titleLabel.textColor = UIColor(named: "Text1")
        self.loadUnreadItem()
    }


    /// MARK: - event listener

    /**
     * called when touched up inside
     * @param barButtonItem UIBarButtonItem
     **/
    @objc func barButtonItemTouchedUpInside(barButtonItem: UIBarButtonItem) {
        if barButtonItem == self.navigationItem.leftBarButtonItem {
            self.navigationController?.popViewController(animated: true)
        }
        else if barButtonItem == self.navigationItem.rightBarButtonItem {
            if self.unread == nil { return }
            let title = self.unread!.getTitle(at: self.index)!
            let link = self.unread!.getLink(at: self.index)!

            KSToastView.ks_showToast("Added a pin\n\(title)", duration: 2.0)

            if !(LDRPin.alreadySavedPin(link: link.absoluteString, title: title)) {
                let error = LDRPin.saveByAttributes(createdOn: "", title: title, link: link.absoluteString)
                if error == nil {
                    LDRPinOperationQueue.shared.requestPinAdd(
                        link: link,
                        title: title,
                        completionHandler: { (json: JSON?, error: Error?) -> Void in }
                    )
                }
            }
        }
    }

    /**
     * called when touched up inside
     * @param button UIButton
     **/
    @IBAction func buttonTouchedUpInside(button: UIButton) {
        if button == self.headerButton {
            if self.unread == nil { return }
            if self.index < 0 { return }
            if self.index >= self.unread!.items.count { return }

            // browser
            let url = self.unread!.getLink(at: self.index)
            if url != nil { self.presentSafari(url: url!) }
        }
        if button == self.backButton {
            if !(self.addIndexIfPossible(value: -1)) { LDRBlinkView.show(on: UIApplication.shared.windows[0], color: UIColor.systemGray6.withAlphaComponent(0.5), count: 1, interval: 0.08) }
            else { self.loadUnreadItem() }

        }
        if button == self.nextButton {
            if !(self.addIndexIfPossible(value: 1)) { LDRBlinkView.show(on: UIApplication.shared.windows[0], color: UIColor.systemGray6.withAlphaComponent(0.5), count: 1, interval: 0.08) }
            else { self.loadUnreadItem() }
        }
    }


    /// MARK: - public api

    /**
     * present safari
     * @param url URL
     **/
    func presentSafari(url: URL) {
        let viewController = SFSafariViewController(url: url)
        viewController.hidesBottomBarWhenPushed = true
        viewController.dismissButtonStyle = .close
        self.present(viewController, animated: true, completion: {})
    }

    /**
     * load unread item
     **/
    func loadUnreadItem() {
        if self.unread == nil { return }

        self.backButton.alpha = (self.index != 0) ? 1.0 : 0.5
        self.nextButton.alpha = (self.index < self.unread!.items.count-1) ? 1.0 : 0.5

        //self.title = self.unread!.getTitle(at: self.index)
        self.titleLabel.text = self.unread!.getTitle(at: self.index)

        self.headerButton.setTitle("\(self.index+1) / \(self.unread!.items.count)", for: .normal)

        let backgroundColor = self.traitCollection.userInterfaceStyle == .dark ? "background: #333;" : "background: #fff;"
        let color = self.traitCollection.userInterfaceStyle == .dark ? "color: #E0E0E0;" : "color: #333;"
        var html = "<html><style>html { width: 100%; \(backgroundColor) \(color) } body { font-size: 3.2em; width: 90%; margin-left: auto; margin-right: auto; margin-top: 1.0em; margin-bottom: 1.0em; } a { color: #5555ff; }</style><body>"
        let body = self.unread!.getBody(at: self.index)
        if body != nil { html = html + "\(body!)" }
        html = html + "</body></html>"
        let link = self.unread!.getLink(at: self.index)
        self.webView.loadHTMLString(html, baseURL: link)
    }

    /**
     * add index
     * @param value Int
     * @return Bool if could add or not
     **/
    func addIndexIfPossible(value: Int) -> Bool {
        if self.unread == nil { return false }

        let newValue = self.index + value
        if newValue < 0 { return false }
        if newValue >= self.unread!.items.count { return false }
        self.index = newValue
        return true
    }
}


/// MARK: - UIGestureRecognizerDelegate
extension LDRFeedDetailViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

/// MARK: - WKNavigationDelegate
extension LDRFeedDetailViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
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
        }
        decisionHandler(.allow)
    }

}
