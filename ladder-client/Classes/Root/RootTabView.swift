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
        TabView(selection: $viewModel.selectedTab) {
            FeedView(viewModel: viewModel.feedViewModel)
            PinView(viewModel: viewModel.pinViewModel)
        }
    }
    
    // MARK: - Init
    
    init(viewModel: RootTabViewModel) {
        self.viewModel = viewModel
    }
}
