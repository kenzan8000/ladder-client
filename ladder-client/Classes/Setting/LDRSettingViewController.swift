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

    @IBOutlet weak var urlDomainLabel: UILabel!
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

        // url domain label rounded corner
        let urlDomainLabelMaskLayer = CAShapeLayer()
        urlDomainLabelMaskLayer.path = UIBezierPath(roundedRect: self.urlDomainLabel.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 4, height: 4)).cgPath
        self.urlDomainLabel.layer.mask = urlDomainLabelMaskLayer

        // login button rounded corner
        let loginButtonMaskLayer = CAShapeLayer()
        loginButtonMaskLayer.path = UIBezierPath(roundedRect: self.loginButton.bounds, cornerRadius: 4).cgPath
        self.loginButton.layer.mask = loginButtonMaskLayer

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
            if self.isLogingIn() { return }

            UserDefaults.standard.setValue(self.usernameTextField.text, forKey: LDRUserDefaults.username)
            UserDefaults.standard.setValue(self.passwordTextField.text, forKey: LDRUserDefaults.password)
            UserDefaults.standard.setValue(self.urlDomainTextField.text, forKey: LDRUserDefaults.ldrUrlString)
            UserDefaults.standard.synchronize()

            self.navigationController?.dismiss(animated: true, completion: {});
        }
    }

    /**
     * called when touched up inside
     * @param button UIButton
     **/
    @IBAction func buttonTouchedUpInside(button: UIButton) {
        if button == self.loginButton {
            if self.isLogingIn() { return }

            UserDefaults.standard.setValue(self.usernameTextField.text, forKey: LDRUserDefaults.username)
            UserDefaults.standard.setValue(self.passwordTextField.text, forKey: LDRUserDefaults.password)
            UserDefaults.standard.setValue(self.urlDomainTextField.text, forKey: LDRUserDefaults.ldrUrlString)
            UserDefaults.standard.synchronize()

            self.startLogin()
        }
    }


    /// MARK: - public api


    /// MARK: - private api

    /**
     * start login
     **/
    private func startLogin() {
        self.loginButton.alpha = 0.35
        self.navigationItem.rightBarButtonItem = nil
        LDRSettingLoginOperationQueue.shared.start(completionHandler: { [unowned self] (json: JSON?, error: Error?) -> Void in
            self.endLogin()
            if error == nil {
                self.navigationController?.dismiss(animated: true, completion: {});
            }
        })
    }

    /**
     * end login
     **/
    private func endLogin() {
        self.loginButton.alpha = 1.0
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(withIcon: ion_ios_close_empty, iconColor: UIColor.darkGray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            style: .plain,
            target: self,
            action: #selector(LDRPinViewController.barButtonItemTouchedUpInside)
        )
    }

    /**
     * check if app is loging in now?
     * @return Bool
     **/
    private func isLogingIn() -> Bool {
        if self.loginButton.alpha < 0.9 { return true }
        return false
    }

}
