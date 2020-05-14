import LGRefreshView
import SafariServices
import SwiftyJSON
import UIKit

// MARK: - LDRPinViewController
class LDRPinViewController: UIViewController {

    // MARK: - properties

    var refreshView: LGRefreshView!
    @IBOutlet private weak var tableView: UITableView!

    var pins: [LDRPin] = []
    
    var didGoBackground = false
    var didGoForeground = false
    var neededToReload: Bool {
        didGoBackground && didGoForeground
    }

    // MARK: - destruction

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - life cycle

    override func loadView() {
        super.loadView()

        self.navigationItem.title = "0 pins"

        // bar button items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(
                withIcon: ion_android_refresh,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            style: .plain,
            target: self,
            action: #selector(LDRPinViewController.barButtonItemTouchedUpInside)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(
                withIcon: ion_ios_gear,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            style: .plain,
            target: self,
            action: #selector(LDRPinViewController.barButtonItemTouchedUpInside)
        )
        // refreshView
        self.refreshView = LGRefreshView(scrollView: self.tableView)
        self.refreshView.tintColor = UIColor.systemBlue
        self.refreshView.backgroundColor = UIColor.systemGray5
        self.refreshView.refreshHandler = { [unowned self] (refreshView: LGRefreshView?) -> Void in
            self.refreshView.trigger(animated: true)
            self.requestPinAll()
        }

        // notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRPinViewController.didLogin),
            name: LDRNotificationCenter.didLogin,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRPinViewController.didGetInvalidUrlOrUsernameOrPasswordError),
            name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRFeedViewController.willResignActive),
            name: LDRNotificationCenter.willResignActive,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRFeedViewController.didBecomeActive),
            name: LDRNotificationCenter.didBecomeActive,
            object: nil
        )

        self.requestPinAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.frame = CGRect(
            x: 0,
            y: self.view.safeAreaInsets.top,
            width: self.tableView.frame.width,
            height: self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - event listener
    
    /// called when touched up inside
    ///
    /// - Parameter barButtonItem: UIBarButtonItem for the event
    @objc func barButtonItemTouchedUpInside(barButtonItem: UIBarButtonItem) {
        if barButtonItem == self.navigationItem.leftBarButtonItem {
            self.requestPinAll()
        } else if barButtonItem == self.navigationItem.rightBarButtonItem {
            guard let vc = LDRSettingNavigationController.ldr_navigationController() else {
                return
            }
            self.present(
                vc,
                animated: true,
                completion: {}
            )
        }
    }

    // MARK: - notification
    
    /// called when user did login
    ///
    /// - Parameter notification: NSNotification happened when user did login
    @objc func didLogin(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.requestPinAll()
        }
    }
    
    /// called when user did get invalid url or username or password error
    ///
    /// - Parameter notification: NSNotification happened when user did get invalid url or username or password error
    @objc func didGetInvalidUrlOrUsernameOrPasswordError(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            guard let nvc = self.navigationController, let tvc = nvc.tabBarController else {
                return
            }
            let viewControllers = tvc.viewControllers
            let selectedIndex = tvc.selectedIndex
            if self.navigationController != viewControllers?[selectedIndex] {
                return
            }

            // display error
            let message = LDRErrorMessage(error: LDRError.invalidUrlOrUsernameOrPassword)
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true) { [unowned self] in
                guard let vc = LDRSettingNavigationController.ldr_navigationController() else {
                    return
                }
                self.present(
                    vc,
                    animated: true,
                    completion: nil
                )
            }
        }
    }
    
    /// called when did get unread
    ///
    /// - Parameter notification: notification happened when application will resign active
    @objc func willResignActive(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.didGoBackground = true
        }
    }
    
    /// called when did get unread
    ///
    /// - Parameter notification: notification happened when application did become active
    @objc func didBecomeActive(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.didGoForeground = true
            if self.neededToReload {
                self.requestPinAll()
            }
        }
    }
    
    // MARK: - public api
    
    /// request pin/all api
    func requestPinAll() {
        self.didGoForeground = false
        self.didGoBackground = false

        LDRPinOperationQueue.shared.requestPinAll { [unowned self] (json: JSON?, error: Error?) -> Void in
            self.refreshView.endRefreshing()
            if let e = error {
                LDRLOG(e.localizedDescription)
                return
            }

            // delete and save model
            if LDRPin.deleteAll() != nil {
                return
            }
            guard let j = json else {
                return
            }
            if LDRPin.save(json: j) != nil {
                return
            }
            self.reloadData()
        }
    }

    /// reload data on tableView
    func reloadData() {
        self.pins = LDRPin.fetch()
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDRPinViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.pins.count
        self.navigationItem.title = "\(count) pins"
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = LDRPinTableViewCell.ldr_cell() else {
            return UITableViewCell()
        }
        cell.setName(self.pins[indexPath.row].title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let pin = self.pins[indexPath.row]

        if let linkUrl = pin.linkUrl {
            // delete model on fastladder
            LDRPinOperationQueue.shared.requestPinRemove(link: linkUrl) { _, _ in }
            // browser
            let viewController = SFSafariViewController(url: linkUrl)
            viewController.hidesBottomBarWhenPushed = true
            viewController.dismissButtonStyle = .close
            self.present(viewController, animated: true) {}
        }

        // delete local model
        if let error = LDRPin.delete(pin: pin) {
            LDRLOG(error.localizedDescription)
        }
        self.reloadData()
    }

}
