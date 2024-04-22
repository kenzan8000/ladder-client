import SwiftUI

// MARK: - RootTabView

struct RootTabView: View {
    // MARK: - Public enums
    
    enum Tab {
        case feeds
        case pins
    }

    // MARK: - Private properties

    @State private var selectedTab: Tab
    
    // MARK: - Public properties

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedsView()
            NavigationView {
                Text("Read Later")
            }
            .tabItem {
                Image(systemName: "pin.fill")
                Text("Read Later")
            }
        }
    }
    
    // MARK: - Init
    
    init(selectedTab: Tab) {
        self.selectedTab = selectedTab
    }
}
