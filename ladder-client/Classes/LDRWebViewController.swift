import UIKit
import WebKit


/// MARK: - LDRWebViewController
class LDRWebViewController: UIViewController {

    // MARK: - properties

    var refreshView: LGRefreshView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!

    var initialUrl: URL?


    /// MARK: - class method

    /**
     * get viewController
     * @return LDRWebViewController
     **/
    class func ldr_viewController() -> LDRWebViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LDRNSStringFromClass(LDRWebViewController.self)) as! LDRWebViewController
        return vc
    }


    /// MARK: - destruction

    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "loading")
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

        // progress bar
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        // refreshView
        self.refreshView = LGRefreshView(scrollView: self.webView.scrollView)
        self.refreshView.tintColor = UIColor.gray
        self.refreshView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        self.refreshView.refreshHandler = { [unowned self] (refreshView: LGRefreshView?) -> Void in
            self.refreshView.trigger(animated: true)
            self.webView.reload()
        }

        self.load(url: self.initialUrl)
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


    /// MARK: - ovserver

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        }
        else if keyPath == "loading" {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webView.isLoading
            if self.webView.isLoading {
                self.progressView.setProgress(0.1, animated: true)
            }
            else {
                self.refreshView.endRefreshing()
                self.progressView.setProgress(0.0, animated: false)
            }
        }
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
        }
    }


    // MARK: - public api

    /**
     * load url
     * @param url URL?
     **/
    func load(url: URL?) {
        if url != nil { self.webView.load(URLRequest(url: url!)) }
    }

}


/// MARK: - UIGestureRecognizerDelegate
extension LDRWebViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
