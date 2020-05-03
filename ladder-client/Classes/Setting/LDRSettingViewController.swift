import KeychainAccess
import SwiftyJSON
import UIKit


/// MARK: - LDRSettingNavigationController
class LDRSettingNavigationController: UINavigationController {

    /// MARK: - class method
    
    /// returns  navigation controller object
    ///
    /// - Returns: navigation controller object
    class func ldr_navigationController() -> LDRSettingNavigationController {
        let nc = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: LDRNSStringFromClass(LDRSettingNavigationController.self)
        ) as! LDRSettingNavigationController
        return nc
    }
}


/// MARK: - LDRSettingViewController
class LDRSettingViewController: UIViewController {

    // MARK: - properties

    @IBOutlet weak var settingView: UIView!

    @IBOutlet weak var urlDomainLabel: UILabel!
    @IBOutlet weak var urlDomainTextField: UITextField!
    //
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginActivityIndicatorView: UIActivityIndicatorView!


    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"

        // bar button items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(
                withIcon: ion_ios_close_empty,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            style: .plain,
            target: self,
            action: #selector(LDRPinViewController.barButtonItemTouchedUpInside)
        )

        // url domain label rounded corner
        let urlDomainLabelMaskLayer = CAShapeLayer()
        urlDomainLabelMaskLayer.path = UIBezierPath(
            roundedRect: self.urlDomainLabel.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 4, height: 4)
        ).cgPath
        self.urlDomainLabel.layer.mask = urlDomainLabelMaskLayer

        // login button rounded corner
        let loginButtonMaskLayer = CAShapeLayer()
        loginButtonMaskLayer.path = UIBezierPath(
            roundedRect: self.loginButton.bounds,
            cornerRadius: 4
        ).cgPath
        self.loginButton.layer.mask = loginButtonMaskLayer

        // login indicator view hidden
        self.loginActivityIndicatorView.isHidden = true

        // text fields
        self.usernameTextField.textContentType = .username
        self.usernameTextField.keyboardType = .alphabet
        self.passwordTextField.textContentType = .password
        let urlDomain = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.ldrUrlString]
        if urlDomain != nil { self.urlDomainTextField.text = urlDomain! }
        self.urlDomainTextField.keyboardType = .URL
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.settingView.frame = CGRect(
            x: 0,
            y: self.view.safeAreaInsets.top,
            width: self.settingView.frame.width,
            height: self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener
    ///
    /// called when touched up inside
    ///
    /// - Parameter barButtonItem: UIBarButtonItem for the event
    @objc func barButtonItemTouchedUpInside(barButtonItem: UIBarButtonItem) {
        if barButtonItem == self.navigationItem.rightBarButtonItem {
            if self.isLogingIn() { return }

            self.saveSettings()

            self.navigationController?.dismiss(animated: true, completion: {})
        }
    }

    /// called when touched up inside
    ///
    /// - Parameter button: UIButton for the event
    @IBAction func buttonTouchedUpInside(button: UIButton) {
        if button == self.loginButton {
            if self.isLogingIn() { return }

            self.saveSettings()

            self.startLogin()
        }
    }


    /// MARK: - public api


    /// MARK: - private api
    ///
    /// save the current settings
    private func saveSettings() {
        Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.username] = self.usernameTextField.text
        Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.password] = self.passwordTextField.text
        
        var urlDomain = self.urlDomainTextField.text
        if urlDomain != nil {
             while urlDomain!.hasSuffix("/") {
                urlDomain = String(urlDomain!.dropLast(1))
            }

        }
        Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.ldrUrlString] = urlDomain
    }
    
    /// start login
    private func startLogin() {
        self.loginButton.setTitleColor(UIColor.clear, for: .normal)
        self.loginButton.setTitleColor(UIColor.clear, for: .selected)
        self.loginButton.setTitleColor(UIColor.clear, for: .highlighted)
        self.loginActivityIndicatorView.isHidden = false
        self.loginActivityIndicatorView.startAnimating()
        self.navigationItem.rightBarButtonItem = nil
        LDRSettingLoginOperationQueue.shared.start(completionHandler: { [unowned self] (json: JSON?, error: Error?) -> Void in
            if error == nil {
                self.navigationController?.dismiss(animated: true, completion: {});
            }
            else {
                self.endLogin()
                // display error
                let message = LDRErrorMessage(error: error)
                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    /// end login
    private func endLogin() {
        self.loginButton.setTitleColor(UIColor.systemGray, for: .normal)
        self.loginButton.setTitleColor(UIColor.systemGray5, for: .selected)
        self.loginButton.setTitleColor(UIColor.systemGray5, for: .highlighted)
        self.loginActivityIndicatorView.isHidden = true
        self.loginActivityIndicatorView.stopAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: IonIcons.image(
                withIcon: ion_ios_close_empty,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ),
            style: .plain,
            target: self,
            action: #selector(LDRPinViewController.barButtonItemTouchedUpInside)
        )
    }
    
    /// returns if loging in now
    /// 
    /// - Returns: Bool value if loging in now
    private func isLogingIn() -> Bool {
        return !(self.loginActivityIndicatorView.isHidden)
    }

}
