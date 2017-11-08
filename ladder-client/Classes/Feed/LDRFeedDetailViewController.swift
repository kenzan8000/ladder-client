import UIKit
import WebKit
import SafariServices


/// MARK: - LDRFeedDetailViewController
class LDRFeedDetailViewController: UIViewController {

    // MARK: - properties

    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var webView: WKWebView!

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

        // bar button items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_arrow_left, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_pin, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )
        // back and next button
        self.backButton.setImage(IonIcons.image(withIcon: ion_ios_arrow_left, iconColor: UIColor.darkGray, iconSize: 36, imageSize: CGSize(width: 36, height: 36)), for: .normal)
        self.nextButton.setImage(IonIcons.image(withIcon: ion_ios_arrow_right, iconColor: UIColor.darkGray, iconSize: 36, imageSize: CGSize(width: 36, height: 36)), for: .normal)

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

        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener

    /**
     * called when touched up inside
     * @param barButtonItem UIBarButtonItem
     **/
    func barButtonItemTouchedUpInside(barButtonItem: UIBarButtonItem) {
        if barButtonItem == self.navigationItem.leftBarButtonItem {
            self.navigationController?.popViewController(animated: true)
        }
        else if barButtonItem == self.navigationItem.rightBarButtonItem {
            if self.unread == nil { return }
            let title = self.unread!.getTitle(at: self.index)!
            let link = self.unread!.getLink(at: self.index)!
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
            if url != nil {
                let viewController = SFSafariViewController(url: url!)
                viewController.hidesBottomBarWhenPushed = true
                viewController.dismissButtonStyle = .close
                self.present(viewController, animated: true, completion: {})
            }
        }
        if button == self.backButton {
            if !(self.addIndexIfPossible(value: -1)) { LDRBlinkView.show(on: UIApplication.shared.windows[0], color: UIColor(white: 1.0, alpha: 0.3), count: 1, interval: 0.08) }
            else { self.loadUnreadItem() }

        }
        if button == self.nextButton {
            if !(self.addIndexIfPossible(value: 1)) { LDRBlinkView.show(on: UIApplication.shared.windows[0], color: UIColor(white: 1.0, alpha: 0.3), count: 1, interval: 0.08) }
            else { self.loadUnreadItem() }
        }
    }


    /// MARK: - public api

    /**
     * load unread item
     **/
    func loadUnreadItem() {
        if self.unread == nil { return }

        self.title = self.unread!.getTitle(at: self.index)

        self.headerButton.setTitle("\(self.index+1) / \(self.unread!.items.count)", for: .normal)

        var html = ""
        let body = self.unread!.getBody(at: self.index)
        if body != nil { html = html + "\(body!)" }
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
