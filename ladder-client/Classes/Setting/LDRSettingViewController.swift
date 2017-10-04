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

    @IBOutlet weak var urlProtocolImageView: UIImageView!
    @IBOutlet weak var urlProtocolButton: UIButton!
    @IBOutlet weak var urlDomainTextField: UITextField!
    //
    @IBOutlet weak var urlProtocolPickerOverlayView: UIView!
    @IBOutlet weak var urlProtocolPickerBackgroundView: UIView!
    @IBOutlet weak var urlProtocolPickerView: UIPickerView!
    @IBOutlet weak var urlProtocolPickerButton: UIButton!
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

        // image view
        self.urlProtocolImageView.image = IonIcons.image(withIcon: ion_arrow_down_b, iconColor: UIColor.darkGray, iconSize: 24, imageSize: CGSize(width: 24, height: 24))
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
            self.presentPicker()
        }
        else if button == self.urlProtocolPickerButton {
            self.dismissPicker()
        }
    }


    /// MARK: - public api

    /**
     * present picker uis
     **/
    func presentPicker() {
        self.urlProtocolPickerOverlayView.isHidden = false
        self.urlProtocolPickerOverlayView.alpha = 0.0
        self.urlProtocolPickerBackgroundView.frame = CGRect(x: 0, y: self.urlProtocolPickerOverlayView.frame.height, width: self.urlProtocolPickerBackgroundView.frame.width, height: self.urlProtocolPickerBackgroundView.frame.height)
        UIView.animate(
            withDuration: 0.22,
            delay: 0.0,
            options: .curveEaseOut,
            animations: { [unowned self] in
                self.urlProtocolPickerOverlayView.alpha = 1.0
                self.urlProtocolPickerBackgroundView.frame = CGRect(x: 0, y: self.urlProtocolPickerOverlayView.frame.height-self.urlProtocolPickerBackgroundView.frame.height, width: self.urlProtocolPickerBackgroundView.frame.width, height: self.urlProtocolPickerBackgroundView.frame.height)
            },
            completion: { [unowned self] finished in
            }
        )
    }

    /**
     * dismiss picker uis
     **/
    func dismissPicker() {
        self.urlProtocolPickerOverlayView.alpha = 1.0
        self.urlProtocolPickerBackgroundView.frame = CGRect(x: 0, y: self.urlProtocolPickerOverlayView.frame.height-self.urlProtocolPickerBackgroundView.frame.height, width: self.urlProtocolPickerBackgroundView.frame.width, height: self.urlProtocolPickerBackgroundView.frame.height)
        UIView.animate(
            withDuration: 0.18,
            delay: 0.0,
            options: .curveEaseOut,
            animations: { [unowned self] in
                self.urlProtocolPickerOverlayView.alpha = 0.0
                self.urlProtocolPickerBackgroundView.frame = CGRect(x: 0, y: self.urlProtocolPickerOverlayView.frame.height, width: self.urlProtocolPickerBackgroundView.frame.width, height: self.urlProtocolPickerBackgroundView.frame.height)
            },
            completion: { [unowned self] finished in
                self.urlProtocolPickerOverlayView.isHidden = true
            }
        )
    }

}


/// MARK: - LDRSettingViewController
extension LDRSettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ["https://", "http://"].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ["https://", "http://"][row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.urlProtocolButton.setTitle(["https://", "http://"][row], for: .normal)
    }

}
