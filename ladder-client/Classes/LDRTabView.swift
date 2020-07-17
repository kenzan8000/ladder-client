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
    
    // MARK: - view
    
    var body: some View {
        TabView(selection: $selected) {
            feedView(tab: selected)
            pinView(tab: selected)
        }
    }

    func feedView(tab: Int) -> some View {
        LDRFeedView(feedViewModel: feedViewModel)
        .tabItem {
            Image(systemName: "wifi")
            Text("RSS Feeds")
        }
        .tag(Tab.feed)
    }
        
    func pinView(tab: Int) -> some View {
        LDRPinView(pinViewModel: pinViewModel)
        .tabItem {
            Image(systemName: "pin.fill")
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
