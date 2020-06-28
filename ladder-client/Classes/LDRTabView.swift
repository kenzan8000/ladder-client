import SwiftUI

// MARK: - LDRTabView
struct LDRTabView: View {
    // MARK: - enum
    
    enum Tab {
        static let feed = 0
        static let pin = 1
    }
    
    @State private var selected = Tab.feed
    
    var body: some View {
        TabView(selection: $selected) {
            feedView(tab: selected)
            pinView(tab: selected)
        }
    }

    func feedView(tab: Int) -> some View {
        LDRFeedView(feedViewModel: LDRFeedViewModel())
        .tabItem {
            if tab == Tab.feed {
                Image(uiImage: IonIcons.image(
                    withIcon: ion_social_rss,
                    iconColor: UIColor.systemGray,
                    iconSize: 25,
                    imageSize: CGSize(width: 75, height: 75)
                ))
            } else {
                Image(uiImage: IonIcons.image(
                    withIcon: ion_social_rss,
                    iconColor: UIColor.systemGray5,
                    iconSize: 25,
                    imageSize: CGSize(width: 75, height: 75)
                ))
            }
        }
        .tag(Tab.feed)
    }
        
    func pinView(tab: Int) -> some View {
        LDRPinView(pinViewModel: LDRPinViewModel())
        .tabItem {
            if tab == Tab.pin {
                Image(uiImage: IonIcons.image(
                    withIcon: ion_pin,
                    iconColor: UIColor.systemGray,
                    iconSize: 25,
                    imageSize: CGSize(width: 75, height: 75)
                ))
            } else {
                Image(uiImage: IonIcons.image(
                    withIcon: ion_pin,
                    iconColor: UIColor.systemGray5,
                    iconSize: 25,
                    imageSize: CGSize(width: 75, height: 75)
                ))
            }
        }
        .tag(Tab.pin)
    }
}

// MARK: - LDRTabView_Previews
struct LDRTabView_Previews: PreviewProvider {
    static var previews: some View {
        LDRTabView()
    }
}

// MARK: - LDRTabViewController
class LDRTabViewController: UIHostingController<LDRTabView> {

    // MARK: - initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(
            coder: aDecoder,
            rootView: LDRTabView()
        )
    }

}
