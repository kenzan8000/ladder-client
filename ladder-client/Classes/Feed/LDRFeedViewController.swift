import UIKit


/// MARK: - LDRFeedViewController
class LDRFeedViewController: UIViewController {

    // MARK: - properties

    @IBOutlet weak var segmentedControl: UISegmentedControl!


    // MARK: - life cycle

    override func loadView() {
        super.loadView()

        // segmented control
        self.segmentedControl.setImage(
            IonIcons.image(withIcon: ion_ios_star_outline, iconColor: UIColor.gray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            forSegmentAt: 0
        )
        self.segmentedControl.setImage(
            IonIcons.image(withIcon: ion_ios_folder_outline, iconColor: UIColor.gray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            forSegmentAt: 1
        )
        // bar button items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_reload, iconColor: UIColor.gray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_gear_outline, iconColor: UIColor.gray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRFeedViewController.barButtonItemTouchedUpInside)
        )
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

