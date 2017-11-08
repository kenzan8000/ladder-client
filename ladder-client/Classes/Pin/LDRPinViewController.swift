import UIKit
import SafariServices


/// MARK: - LDRPinViewController
class LDRPinViewController: UIViewController {

    // MARK: - properties

    var refreshView: LGRefreshView!
    @IBOutlet weak var tableView: UITableView!

    var pins: [LDRPin] = []


    /// MARK: - destruction

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "0 pins"

        // bar button items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_reload, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRPinViewController.barButtonItemTouchedUpInside)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_gear_outline, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRPinViewController.barButtonItemTouchedUpInside)
        )
        // refreshView
        self.refreshView = LGRefreshView(scrollView: self.tableView)
        self.refreshView.tintColor = UIColor.gray
        self.refreshView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        self.refreshView.refreshHandler = { [unowned self] (refreshView: LGRefreshView?) -> Void in
            self.refreshView.trigger(animated: true)
            self.requestPinAll()
        }

        // notification
        NotificationCenter.default.addObserver(self, selector: #selector(LDRPinViewController.didLogin), name: LDRNotificationCenter.didLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LDRPinViewController.didGetInvalidUrlOrUsernameOrPasswordError), name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError, object: nil)


        self.reloadData()
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
            self.requestPinAll()
        }
        else if barButtonItem == self.navigationItem.rightBarButtonItem {
            self.present(LDRSettingNavigationController.ldr_navigationController(), animated: true, completion: {})
        }
    }


    /// MARK: - notification

    /**
     * called when did login
     * @param notification NSNotification
     **/
    func didLogin(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.requestPinAll()
        }
    }

    /**
     * called when did get invalid url or username or password error
     * @param notification NSNotification
     **/
    func didGetInvalidUrlOrUsernameOrPasswordError(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            if self.navigationController != self.navigationController!.tabBarController!.viewControllers![self.navigationController!.tabBarController!.selectedIndex] { return }

            // display error
            let message = LDRErrorMessage(error: LDRError.invalidUrlOrUsernameOrPassword)
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: { [unowned self] in
                self.present(LDRSettingNavigationController.ldr_navigationController(), animated: true, completion: {})
            })
        }
    }


    /// MARK: - public api

    /**
     * request pin/all
     **/
    func requestPinAll() {
        LDRPinOperationQueue.shared.requestPinAll(completionHandler: { [unowned self] (json: JSON?, error: Error?) -> Void in
            self.refreshView.endRefreshing()

            if error != nil { return }

            // delete and save model
            var modelError: Error? = nil
            modelError = LDRPin.deleteAll()
            if modelError != nil { return }

            if json == nil { return }
            modelError = LDRPin.save(json: json!)
            if modelError != nil { return }
            self.reloadData()
        })
    }

    /**
     * reload data on tableView
     **/
    func reloadData() {
        self.pins = LDRPin.fetch()
        self.tableView.reloadData()
    }
}


/// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDRPinViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.pins.count
        self.navigationItem.title = "\(count) pins"
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LDRPinTableViewCell.ldr_cell()
        cell.nameLabel.text = self.pins[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let pin = self.pins[indexPath.row]

        if pin.linkUrl != nil {
/*
            // delete model on fastladder
            LDRPinOperationQueue.shared.requestPinRemove(
                link: pin.linkUrl!,
                completionHandler: { (json: JSON?, error: Error?) -> Void in }
            )
*/
            // browser
            let viewController = SFSafariViewController(url: pin.linkUrl!)
            viewController.hidesBottomBarWhenPushed = true
            viewController.dismissButtonStyle = .close
            self.present(viewController, animated: true, completion: {})
        }

        // delete local model
        LDRPin.delete(pin: pin)
        self.reloadData()
    }

}
