import UIKit


/// MARK: - LDRFeedDetailViewController
class LDRFeedDetailViewController: UIViewController {

    // MARK: - properties


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
            image: IonIcons.image(withIcon: ion_ios_arrow_back, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.navigationController!.popViewController(animated: true)
        }
        else if barButtonItem == self.navigationItem.rightBarButtonItem {
        }
    }

}
