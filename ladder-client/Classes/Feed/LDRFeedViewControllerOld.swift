import LGRefreshView
import SwiftyJSON
import UIKit

// MARK: - LDRFeedViewControllerOld
class LDRFeedViewControllerOld: UIViewController {

    // MARK: - properties

    var refreshView: LGRefreshView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    enum Segment {
        static let rate = 0
        static let folder = 1
    }
    @IBOutlet private weak var tableView: UITableView!

    var subsunreads: [LDRFeedSubsUnread] = []
    var unreads: [LDRFeedUnread] = []
    var rates: [Int] = []
    var folders: [String] = []
    
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

        self.initNavigationBar()
        
        // refreshView
        self.refreshView = LGRefreshView(scrollView: self.tableView)
        self.refreshView.tintColor = UIColor.systemBlue
        self.refreshView.backgroundColor = UIColor.systemGray6
        self.refreshView.refreshHandler = { [unowned self] (refreshView: LGRefreshView?) -> Void in
            self.refreshView.trigger(animated: true)
            self.requestSubs()
        }

        self.initNotifications()

        self.requestSubs()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

    /// called when value changed
    ///
    /// - Parameter segmentedControl: UISegmentedControl for the event
    @IBAction private func segmentedControlValueChanged(segmentedControl: UISegmentedControl) {
        self.reloadData(isNew: false)
    }

    /// called when touched up inside
    ///
    /// - Parameter barButtonItem: UIBarButtonItem for the event
    @objc
    func barButtonItemTouchedUpInside(barButtonItem: UIBarButtonItem) {
        if barButtonItem == self.navigationItem.rightBarButtonItem {
            self.requestSubs()
        } else if barButtonItem == self.navigationItem.leftBarButtonItem {
            guard let vc = UIStoryboard(
                name: "Main",
                bundle: nil
            ).instantiateViewController(
                identifier: LDRNSStringFromClass(LDRLoginViewController.self)
            ) as? LDRLoginViewController else {
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

    /// called when did login
    ///
    /// - Parameter notification: notification happened when user did login
    @objc
    func didLogin(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.requestSubs()
        }
    }

    /// called when did get unread
    ///
    /// - Parameter notification: notification happened when user did get new unread
    @objc
    func didGetUnread(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.reloadVisibleCells()
        }
    }

    /// called when user did get invalid url or username or password error
    ///
    /// - Parameter notification: notification happened when user did get invalid url or username or password error
    @objc
    func didGetInvalidUrlOrUsernameOrPasswordError(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            guard let nvc = self.navigationController, let tvc = nvc.tabBarController else {
                return
            }
            let viewControllers = tvc.viewControllers
            let selectedIndex = tvc.selectedIndex
            if viewControllers?[selectedIndex] != self.navigationController {
                return
            }

            // display error
            let message = LDRErrorMessage(error: LDRError.invalidUrlOrUsernameOrPassword)
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(
                alertController,
                animated: true
            ) { [unowned self] in
                guard let vc = UIStoryboard(
                    name: "Main",
                    bundle: nil
                ).instantiateViewController(
                    identifier: LDRNSStringFromClass(LDRLoginViewController.self)
                ) as? LDRLoginViewController else {
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
    @objc
    func willResignActive(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.didGoBackground = true
        }
    }
    
    /// called when did get unread
    ///
    /// - Parameter notification: notification happened when application did become active
    @objc
    func didBecomeActive(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.didGoForeground = true
            if self.neededToReload {
                self.requestSubs()
            }
        }
    }
    
    // MARK: - public api

    /// returns index int from index path on feed view controller
    ///
    /// - Parameter indexPath: IndexPath object
    /// - Returns: index int from index path
    func getIndex(indexPath: IndexPath) -> Int {
        var index = 0
        for section in 0 ..< indexPath.section {
            if self.segmentedControl.selectedSegmentIndex == Segment.rate {
                let offset = LDRFeedSubsUnread.countOfTheRateInt(
                    subsunreads: self.subsunreads,
                    rate: self.rates[section]
                )
                index += offset
            } else if self.segmentedControl.selectedSegmentIndex == Segment.folder {
                let offset = LDRFeedSubsUnread.countOfTheFloder(
                    subsunreads: self.subsunreads,
                    folder: self.folders[section]
                )
                index += offset
            }
        }
        index += indexPath.row
        return index
    }

    /// request subs api
    func requestSubs() {
        self.didGoForeground = false
        self.didGoBackground = false
        
        LDRFeedOperationQueue.shared.requestSubs { [unowned self] (json: JSON?, error: Error?) -> Void in
            self.refreshView.endRefreshing()
            if let e = error {
                LDRLOG(e.localizedDescription)
                return
            }
        
            // delete and save model
            if LDRFeedSubsUnread.delete() != nil {
                return
            }
            guard let j = json else {
                return
            }
            if LDRFeedSubsUnread.save(json: j) != nil {
                return
            }
            self.reloadData(isNew: true)
        }
    }

    /// update subsunread models and tableView
    ///
    /// - Parameter isNew: if newly adding LDRFeedUnread
    func reloadData(isNew: Bool) {
        self.subsunreads = LDRFeedSubsUnread.fetch(
            segment: self.segmentedControl.selectedSegmentIndex
        )
        if isNew {
            self.unreads = []
            for subsunread in self.subsunreads {
                let unread = LDRFeedUnread(subscribeId: subsunread.subscribeId, title: subsunread.title)
                self.unreads.append(unread)
                unread.request { _ in }
            }
        } else {
            var newUnreads: [LDRFeedUnread] = []
            for subsunread in self.subsunreads {
                if let i = self.unreads.firstIndex(where: {
                    $0.subscribeId == subsunread.subscribeId
                }) {
                    newUnreads.append(self.unreads[i])
                }
            }
            self.unreads = newUnreads
        }
        if self.segmentedControl.selectedSegmentIndex == Segment.rate {
            self.rates = LDRFeedSubsUnread.getRateInts(subsunreads: self.subsunreads)
        } else if self.segmentedControl.selectedSegmentIndex == Segment.folder {
            self.folders = LDRFeedSubsUnread.getFolders(subsunreads: self.subsunreads)
        }
        self.tableView.reloadData()
    }

    /// update visible tableview cells
    func reloadVisibleCells() {
        guard let indexPaths = self.tableView.indexPathsForVisibleRows else {
            return
        }
        for indexPath in indexPaths {
            guard let cell = self.tableView.cellForRow(at: indexPath) as? LDRFeedTableViewCell else {
                continue
            }
            let index = self.getIndex(indexPath: indexPath)
            cell.setUIState(self.unreads[index].state)
        }
    }

    // MARK: - private api
    
    /// Initialize Navigation Bar
    private func initNavigationBar() {
        // segmented control
        self.segmentedControl.setImage(
            IonIcons.image(
                withIcon: ion_ios_star,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            forSegmentAt: Segment.rate
        )
        self.segmentedControl.setImage(
            IonIcons.image(
                withIcon: ion_ios_folder,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            forSegmentAt: Segment.folder
        )
        // bar button items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(
                withIcon: ion_log_in,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewControllerOld.barButtonItemTouchedUpInside)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(
                withIcon: ion_android_refresh,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewControllerOld.barButtonItemTouchedUpInside)
        )
    }
    
    /// Initialize Notifications
    private func initNotifications() {
        // notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRFeedViewControllerOld.didLogin),
            name: LDRNotificationCenter.didLogin,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRFeedViewControllerOld.didGetUnread),
            name: LDRNotificationCenter.didGetUnread,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRFeedViewControllerOld.didGetInvalidUrlOrUsernameOrPasswordError),
            name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRFeedViewControllerOld.willResignActive),
            name: LDRNotificationCenter.willResignActive,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRFeedViewControllerOld.didBecomeActive),
            name: LDRNotificationCenter.didBecomeActive,
            object: nil
        )
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDRFeedViewControllerOld: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.segmentedControl.selectedSegmentIndex == Segment.rate {
            return self.rates.count
        } else if self.segmentedControl.selectedSegmentIndex == Segment.folder {
            return self.folders.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == Segment.rate {
            return LDRFeedSubsUnread.countOfTheRateInt(subsunreads: self.subsunreads, rate: self.rates[section])
        } else if self.segmentedControl.selectedSegmentIndex == Segment.folder {
            return LDRFeedSubsUnread.countOfTheFloder(subsunreads: self.subsunreads, folder: self.folders[section])
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = LDRFeedViewForHeader.ldr_view() else {
            return nil
        }
        headerView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: headerView.frame.size.height)
        if self.segmentedControl.selectedSegmentIndex == Segment.rate {
            headerView.setTitle(LDRFeedSubsUnread.getRateName(rate: self.rates[section]))
        } else if self.segmentedControl.selectedSegmentIndex == Segment.folder {
            headerView.setTitle(self.folders[section])
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = LDRFeedTableViewCell.ldr_cell() else {
            return UITableViewCell()
        }
        let index = self.getIndex(indexPath: indexPath)
        cell.setTexts(name: self.subsunreads[index].title, unreadCount: "\(self.subsunreads[index].unreadCountValue)")
        cell.setUIState(self.unreads[index].state)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let index = self.getIndex(indexPath: indexPath)
        switch self.unreads[index].state {
        case LDRFeedTableViewCell.State.unread:
            self.unreads[index].state = LDRFeedTableViewCell.State.read
            self.unreads[index].requestTouchAll()
        case LDRFeedTableViewCell.State.read:
            self.unreads[index].state = LDRFeedTableViewCell.State.read
        case LDRFeedTableViewCell.State.unloaded:
            return
        case LDRFeedTableViewCell.State.noUnread:
            return
        default:
            return
        }
        if let cell = self.tableView.cellForRow(at: indexPath) as? LDRFeedTableViewCell {
            cell.setUIState(self.unreads[index].state)
        }

        guard let viewController = LDRFeedDetailViewControllerOld.ldr_viewController() else {
            return
        }
        viewController.hidesBottomBarWhenPushed = true
        viewController.unread = self.unreads[index]
        self.navigationController?.show(viewController, sender: nil)
    }

}