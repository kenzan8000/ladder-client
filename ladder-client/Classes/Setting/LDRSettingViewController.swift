import UIKit


/// MARK: - LDRSettingNavigationController
class LDRSettingNavigationController: UINavigationController {

    /// MARK: - class method

    /**
     * get navigationController
     * @return LDRSettingNavigationController
     **/
    class func ldr_navigationController() -> LDRSettingNavigationController {
        let nc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LDRNSStringFromClass(LDRSettingNavigationController.self)) as! LDRSettingNavigationController
        return nc
    }
}


/// MARK: - LDRSettingViewController
class LDRSettingViewController: UIViewController {

    // MARK: - properties

    @IBOutlet weak var urlProtocolButton: UIButton!
    @IBOutlet weak var urlDomainTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!


    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // bar button items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_close_empty, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRPinViewController.barButtonItemTouchedUpInside)
        )
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
        if barButtonItem == self.navigationItem.rightBarButtonItem {
            self.navigationController?.dismiss(animated: true, completion: {});
        }
    }

    /**
     * called when touched up inside
     * @param button UIButton
     **/
    @IBAction func buttonTouchedUpInside(button: UIButton) {
        if button == self.loginButton {
            self.navigationController?.dismiss(animated: true, completion: {});
        }
        else if button == self.urlProtocolButton {
            self.navigationController?.dismiss(animated: true, completion: {});
        }
    }

}
