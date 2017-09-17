import UIKit


/// MARK: - LDRFeedViewController
class LDRFeedViewController: UIViewController {

    // MARK: - properties
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!


    // MARK: - life cycle
    override func loadView() {
        super.loadView()

        // bar button items
        self.leftBarButtonItem.setBackgroundImage(
            IonIcons.image(withIcon: ion_ios_reload, iconColor: UIColor.gray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            for: .normal,
            barMetrics: .defaultPrompt
        )
        self.rightBarButtonItem.setBackgroundImage(
            IonIcons.image(withIcon: ion_ios_settings, iconColor: UIColor.gray, iconSize: 32, imageSize: CGSize(width: 32, height: 32)),
            for: .normal,
            barMetrics: .defaultPrompt
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

