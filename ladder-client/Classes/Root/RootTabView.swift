import SwiftUI

// MARK: - RootTabView

struct RootTabView: View {
    // MARK: - Public enums
    
    enum Tab {
        case feeds
        case pins
    }

    // MARK: - Private properties
    
    @EnvironmentObject private var viewModel: RootTabViewModel

    @State private var selectedTab: Tab
    
    // MARK: - Public properties

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .environmentObject(viewModel.makeFeedViewModel())
            PinView()
                .environmentObject(viewModel.makePinViewModel())
        }
    }
    
    // MARK: - Init
    
    init(selectedTab: Tab) {
        self.selectedTab = selectedTab
    }
}
