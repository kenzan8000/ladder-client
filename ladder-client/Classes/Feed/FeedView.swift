import SwiftUI

// MARK: - FeedView

struct FeedView: View {
    // MARK: - Private properties
    
    @State private var viewModel: FeedViewModel

    // MARK: - Public properties

    var body: some View {
        RootNavigationView(viewModel: viewModel.rootNavigationViewModel) {
            if viewModel.isSignedIn {
                FeedListView(viewModel: viewModel.feedListViewModel)
            } else {
                RootSignInView(viewModel: viewModel.rootSignInViewModel)
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
