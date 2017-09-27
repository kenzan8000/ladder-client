import UIKit


/// MARK: - LDRFeedDetailViewController
class LDRFeedDetailViewController: UIViewController {

    // MARK: - properties

    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!


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
        }
    }

    /**
     * called when touched up inside
     * @param button UIButton
     **/
    @IBAction func buttonTouchedUpInside(button: UIButton) {
        if button == self.headerButton {
        }
        if button == self.backButton {
            LDRBlinkView.show(on: UIApplication.shared.windows[0], color: UIColor(white: 1.0, alpha: 0.3), count: 1, interval: 0.08)
        }
        if button == self.nextButton {
            LDRBlinkView.show(on: UIApplication.shared.windows[0], color: UIColor(white: 1.0, alpha: 0.3), count: 1, interval: 0.08)
        }
    }

}


/// MARK: - UIGestureRecognizerDelegate
extension LDRFeedDetailViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
