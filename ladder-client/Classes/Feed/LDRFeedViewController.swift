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

        self.reloadData()
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
        self.reloadData()
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
     * update subsunread models and tableView
     **/
    func reloadData() {
        self.subsunreads = LDRFeedSubsUnread.fetch(segment: self.segmentedControl.selectedSegmentIndex)
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
        cell.nameLabel.text = self.subsunreads[index].title

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let viewController = LDRFeedDetailViewController.ldr_viewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.show(viewController, sender: nil)
    }

}
