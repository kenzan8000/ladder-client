import SwiftUI

// MARK: - LDRTabView
struct LDRTabView: View {
    // MARK: - enum
    
    enum Tab {
        static let feed = 0
        static let pin = 1
    }
    
    // MARK: - property
    
    @State private var selected = Tab.feed
    var feedViewModel: LDRFeedViewModel
    var pinViewModel: LDRPinViewModel
    
    var body: some View {
        TabView(selection: $selected) {
            feedView(tab: selected)
            pinView(tab: selected)
        }
    }

    func feedView(tab: Int) -> some View {
        LDRFeedView(feedViewModel: feedViewModel)
        .tabItem {
            Image(uiImage: IonIcons.image(
                withIcon: ion_social_rss,
                iconColor: tab == Tab.feed ? UIColor.systemBlue : UIColor.systemGray,
                iconSize: 25,
                imageSize: CGSize(width: 75, height: 75)
            ))
            Text("RSS Feeds")
        }
        .tag(Tab.feed)
    }
        
    func pinView(tab: Int) -> some View {
        LDRPinView(pinViewModel: pinViewModel)
        .tabItem {
            Image(uiImage: IonIcons.image(
                withIcon: ion_pin,
                iconColor: tab == Tab.pin ? UIColor.systemBlue : UIColor.systemGray,
                iconSize: 25,
                imageSize: CGSize(width: 75, height: 75)
            ))
            Text("Read Later Pins")
        }
        .tag(Tab.pin)
    }
}

// MARK: - LDRTabView_Previews
struct LDRTabView_Previews: PreviewProvider {
    static var previews: some View {
        LDRTabView(
            feedViewModel: LDRFeedViewModel(),
            pinViewModel: LDRPinViewModel()
        )
    }
}

// MARK: - LDRTabViewController
class LDRTabViewController: UIHostingController<LDRTabView> {

    // MARK: - initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(
            coder: aDecoder,
            rootView: LDRTabView(
                feedViewModel: LDRFeedViewModel(),
                pinViewModel: LDRPinViewModel()
            )
        )
    }

}
