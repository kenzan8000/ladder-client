import SwiftUI

// MARK: - RootTabView

struct RootTabView: View {
    // MARK: - Public enums
    
    enum Tab {
        case feeds
        case pins
    }

    // MARK: - Private properties
    
    @State private var viewModel: RootTabViewModel
    
    // MARK: - Public properties

    var body: some View {
        NavigationStack {
            TabView(selection: $viewModel.selectedTab) {
                SwiftUI.Tab("RSS Feeds", systemImage: "wifi", value: .feeds) {
                    FeedView(viewModel: viewModel.feedViewModel)
                }
                SwiftUI.Tab("Read Later", systemImage: "bookmark.fill", value: .pins) {
                    PinView(viewModel: viewModel.pinViewModel)
                }
            }
        }
    }
    
    // MARK: - Init
    
    init(viewModel: RootTabViewModel) {
        self.viewModel = viewModel
    }
}
