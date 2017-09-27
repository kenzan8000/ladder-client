import UIKit


/// MARK: - LDRFeedViewController
class LDRFeedViewController: UIViewController {

    // MARK: - properties

    var refreshView: LGRefreshView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!


    // MARK: - life cycle

    override func loadView() {
        super.loadView()

        // segmented control
        self.segmentedControl.setImage(
            IonIcons.image(withIcon: ion_ios_star_outline, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            forSegmentAt: 0
        )
        self.segmentedControl.setImage(
            IonIcons.image(withIcon: ion_ios_folder_outline, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            forSegmentAt: 1
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

    }

    /**
     * called when touched up inside
     * @param barButtonItem UIBarButtonItem
     **/
    func barButtonItemTouchedUpInside(barButtonItem: UIBarButtonItem) {
        if barButtonItem == self.navigationItem.leftBarButtonItem {
        }
        else if barButtonItem == self.navigationItem.rightBarButtonItem {
        }
    }

}


/// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDRFeedViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = LDRFeedViewForHeader.ldr_view()
        headerView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: headerView.frame.size.height)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LDRFeedTableViewCell.ldr_cell()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController!.show(LDRFeedDetailViewController.ldr_viewController(), sender: nil)
    }

}
