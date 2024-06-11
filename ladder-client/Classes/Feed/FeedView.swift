import SwiftUI

// MARK: - FeedView

struct FeedView: View {
    // MARK: - Private properties
    
    @State private var viewModel: FeedViewModel

    // MARK: - Public properties

    var body: some View {
        RootNavigationView(viewModel: viewModel.makeRootNavigationViewModel()) {
            if viewModel.isSignedIn {
                FeedListView(viewModel: viewModel.makeFeedListViewModel())
            } else {
                RootSignInView(viewModel: viewModel.makeRootSignInViewModel())
            }
        }
        .tabItem {
            Image(systemName: "wifi")
            Text("RSS Feeds")
        }
    }
    
    // MARK: - Init
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
}
