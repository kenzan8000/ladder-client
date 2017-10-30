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

    @IBOutlet weak var urlDomainTextField: UITextField!
    //
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //
    @IBOutlet weak var loginButton: UIButton!


    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"

        // bar button items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_close_empty, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRPinViewController.barButtonItemTouchedUpInside)
        )

        // text fields
        let username = UserDefaults.standard.string(forKey: LDRUserDefaults.username)
        if username != nil { self.usernameTextField.text = username! }
        let password = UserDefaults.standard.string(forKey: LDRUserDefaults.password)
        if password != nil { self.passwordTextField.text = password! }
        let urlDomain = UserDefaults.standard.string(forKey: LDRUserDefaults.ldrUrlString)
        if urlDomain != nil { self.urlDomainTextField.text = urlDomain! }
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
            UserDefaults.standard.setValue(self.usernameTextField.text, forKey: LDRUserDefaults.username)
            UserDefaults.standard.setValue(self.passwordTextField.text, forKey: LDRUserDefaults.password)
            UserDefaults.standard.setValue(self.urlDomainTextField.text, forKey: LDRUserDefaults.ldrUrlString)
            UserDefaults.standard.synchronize()

            LDRSettingLoginOperationQueue.shared.start(completionHandler: { [unowned self] (json: JSON?, error: Error?) -> Void in
            })

            self.navigationController?.dismiss(animated: true, completion: {});
        }
    }


    /// MARK: - public api
}
