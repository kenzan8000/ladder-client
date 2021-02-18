import SwiftUI

// MARK: - LDRTabView
struct LDRTabView: View {
    // MARK: - enum
    
    enum Tab: Int {
        case feed = 0
        case pin = 1
    }
    
    // MARK: - property
    
    @State private var selected = Tab.feed
    @StateObject var loginViewModel: LDRLoginViewModel
    var feedViewModel: LDRFeedViewModel
    var pinViewModel: LDRPinViewModel
    
    // MARK: - view
    
    var body: some View {
        TabView(selection: $selected) {
            feedView(tab: selected)
            pinView(tab: selected)
        }
    }

    func feedView(tab: Tab) -> some View {
        LDRFeedView(feedViewModel: feedViewModel, loginViewModel: loginViewModel)
        .tabItem {
            Image(systemName: "wifi")
            Text("RSS Feeds")
        }
        .tag(Tab.feed)
    }
        
    func pinView(tab: Tab) -> some View {
        LDRPinView(pinViewModel: pinViewModel, loginViewModel: loginViewModel)
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
            loginViewModel: LDRLoginViewModel(),
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
                loginViewModel: LDRLoginViewModel(),
                feedViewModel: LDRFeedViewModel(),
                pinViewModel: LDRPinViewModel()
            )
        )
    }

}
