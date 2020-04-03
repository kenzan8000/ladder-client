import UIKit


/// MARK: - LDRTabBarController
class LDRTabBarController: UITabBarController {

    // MARK: - properties


    // MARK: - life cycle

    override func loadView() {
        super.loadView()

        let selectedImages = [
            IonIcons.image(
                withIcon: ion_social_rss,
                iconColor: UIColor.systemGray,
                iconSize: 36,
                imageSize: CGSize(width: 36, height: 36)
            ),
            IonIcons.image(
                withIcon: ion_pin,
                iconColor: UIColor.systemGray,
                iconSize: 36,
                imageSize: CGSize(width: 36, height: 36)
            )
        ]
        let unselectedImages = [
            IonIcons.image(
                withIcon: ion_social_rss,
                iconColor: UIColor.systemGray5,
                iconSize: 36,
                imageSize: CGSize(width: 36, height: 36)
            ),
            IonIcons.image(
                withIcon: ion_pin,
                iconColor: UIColor.systemGray5,
                iconSize: 36,
                imageSize: CGSize(width: 36, height: 36)
            )
        ]
        for (i, item) in self.tabBar.items!.enumerated() {
            item.selectedImage = selectedImages[i];
            item.image = unselectedImages[i];
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
