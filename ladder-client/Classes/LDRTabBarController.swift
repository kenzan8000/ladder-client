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
                iconSize: 25,
                imageSize: CGSize(width: 75, height: 75)
            ),
            IonIcons.image(
                withIcon: ion_pin,
                iconColor: UIColor.systemGray,
                iconSize: 25,
                imageSize: CGSize(width: 75, height: 75)
            )
        ]
        let unselectedImages = [
            IonIcons.image(
                withIcon: ion_social_rss,
                iconColor: UIColor.systemGray5,
                iconSize: 25,
                imageSize: CGSize(width: 75, height: 75)
            ),
            IonIcons.image(
                withIcon: ion_pin,
                iconColor: UIColor.systemGray5,
                iconSize: 25,
                imageSize: CGSize(width: 75, height: 75)
            )
        ]
        for (i, item) in self.tabBar.items!.enumerated() {
            item.selectedImage = selectedImages[i];
            item.image = unselectedImages[i];
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
