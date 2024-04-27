import SwiftUI

// MARK: - FeedView

struct FeedView: View {
    // MARK: - Private properties
    
    @EnvironmentObject private var viewModel: FeedViewModel

    // MARK: - Public properties

    var body: some View {
        RootNavigationView {
            Text("RSS Feeds")
        }
        .tabItem {
            Image(systemName: "wifi")
            Text("RSS Feeds")
        }
        .environmentObject(viewModel.makeRootNavigationViewModel())
    }
}
