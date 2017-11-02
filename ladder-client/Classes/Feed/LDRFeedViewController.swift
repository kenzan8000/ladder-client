import UIKit


/// MARK: - LDRFeedViewController
class LDRFeedViewController: UIViewController {

    // MARK: - properties

    var refreshView: LGRefreshView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    struct segment {
        static let rate = 0
        static let folder = 1
    }
    @IBOutlet weak var tableView: UITableView!

    var subsunreads: [LDRFeedSubsUnread] = []
    var unreads: [LDRFeedUnread] = []
    var rates: [Int] = []
    var folders: [String] = []


    // MARK: - life cycle

    override func loadView() {
        super.loadView()

        // segmented control
        self.segmentedControl.setImage(
            IonIcons.image(withIcon: ion_ios_star_outline, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            forSegmentAt: segment.rate
        )
        self.segmentedControl.setImage(
            IonIcons.image(withIcon: ion_ios_folder_outline, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            forSegmentAt: segment.folder
        )
        // bar button items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_reload, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_gear_outline, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )
        // refreshView
        self.refreshView = LGRefreshView(scrollView: self.tableView)
        self.refreshView.tintColor = UIColor.gray
        self.refreshView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        self.refreshView.refreshHandler = { [unowned self] (refreshView: LGRefreshView?) -> Void in
            self.refreshView.trigger(animated: true)
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                execute: { [unowned self] () -> Void in
                    self.refreshView.endRefreshing()
                }
            )
        }

        self.reloadData(isNew: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener

    /**
     * called when value changed
     * @param segmentedControl UISegmentedControl
     **/
    @IBAction func segmentedControlValueChanged(segmentedControl: UISegmentedControl) {
        self.reloadData(isNew: false)
    }

    /**
     * called when touched up inside
     * @param barButtonItem UIBarButtonItem
     **/
    func barButtonItemTouchedUpInside(barButtonItem: UIBarButtonItem) {
        if barButtonItem == self.navigationItem.leftBarButtonItem {
        }
        else if barButtonItem == self.navigationItem.rightBarButtonItem {
            self.present(LDRSettingNavigationController.ldr_navigationController(), animated: true, completion: {})
        }
    }


    /// MARK: - public api

    /**
     * get index
     * @param indexPath IndexPath
     * @return Int
     **/
    func getIndex(indexPath: IndexPath) -> Int {
        var index = 0
        for section in 0 ..< indexPath.section {
            if self.segmentedControl.selectedSegmentIndex == segment.rate {
                index = index + LDRFeedSubsUnread.countOfTheRate(subsunreads: self.subsunreads, rate: self.rates[section])
            }
            else if self.segmentedControl.selectedSegmentIndex == segment.folder {
                index = index + LDRFeedSubsUnread.countOfTheFloder(subsunreads: self.subsunreads, folder: self.folders[section])
            }
        }
        index = index + indexPath.row
        return index
    }

    /**
     * update subsunread models and tableView
     * @param isNew Bool
     **/
    func reloadData(isNew: Bool) {
        self.subsunreads = LDRFeedSubsUnread.fetch(segment: self.segmentedControl.selectedSegmentIndex)
        if isNew {
            self.unreads = []
            for subsunread in self.subsunreads { self.unreads.append(LDRFeedUnread(subscribeId: subsunread.subscribeId)) }
        }
        else {
            var newUnreads: [LDRFeedUnread] = []
            for subsunread in self.subsunreads {
                if let i = self.unreads.index(where: { $0.subscribeId ==  subsunread.subscribeId }) {
                    newUnreads.append(self.unreads[i])
                }
            }
            self.unreads = newUnreads
        }
        if self.segmentedControl.selectedSegmentIndex == segment.rate {
            self.rates = LDRFeedSubsUnread.getRates(subsunreads: self.subsunreads)
        }
        else if self.segmentedControl.selectedSegmentIndex == segment.folder {
            self.folders = LDRFeedSubsUnread.getFolders(subsunreads: self.subsunreads)
        }
        self.tableView.reloadData()
    }
}


/// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDRFeedViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.segmentedControl.selectedSegmentIndex == segment.rate {
            return self.rates.count
        }
        else if self.segmentedControl.selectedSegmentIndex == segment.folder {
            return self.folders.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == segment.rate {
            return LDRFeedSubsUnread.countOfTheRate(subsunreads: self.subsunreads, rate: self.rates[section])
        }
        else if self.segmentedControl.selectedSegmentIndex == segment.folder {
            return LDRFeedSubsUnread.countOfTheFloder(subsunreads: self.subsunreads, folder: self.folders[section])
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = LDRFeedViewForHeader.ldr_view()
        headerView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: headerView.frame.size.height)
        if self.segmentedControl.selectedSegmentIndex == segment.rate {
            headerView.titleLabel.text = LDRFeedSubsUnread.getRateName(rate: self.rates[section])
        }
        else if self.segmentedControl.selectedSegmentIndex == segment.folder {
            headerView.titleLabel.text = self.folders[section]
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LDRFeedTableViewCell.ldr_cell()
        let index = self.getIndex(indexPath: indexPath)
        cell.nameLabel.text = self.subsunreads[index].title
        cell.unreadCountLabel.text = "\(self.subsunreads[index].unreadCountValue)"
        cell.setUIState(self.unreads[index].state)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let index = self.getIndex(indexPath: indexPath)
        switch self.unreads[index].state {
            case LDRFeedTableViewCell.state.unloaded:
                return
            case LDRFeedTableViewCell.state.unread:
                self.unreads[index].state = LDRFeedTableViewCell.state.read
            case LDRFeedTableViewCell.state.read:
                self.unreads[index].state = LDRFeedTableViewCell.state.read
            case LDRFeedTableViewCell.state.noUnread:
                return
            default:
                return
        }
        let cell = self.tableView.cellForRow(at: indexPath)
        if cell != nil { (cell as! LDRFeedTableViewCell).setUIState(self.unreads[index].state) }

        let viewController = LDRFeedDetailViewController.ldr_viewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.show(viewController, sender: nil)
    }

}
