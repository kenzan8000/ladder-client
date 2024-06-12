import SwiftUI

// MARK: - PinView

struct PinView: View {
    // MARK: - Private properties
    
    @State private var viewModel: PinViewModel

    var body: some View {
        RootNavigationView(viewModel: viewModel.rootNavigationViewModel) {
            if viewModel.isSignedIn {
                PinListView(viewModel: viewModel.pinListViewModel)
            } else {
                RootSignInView(viewModel: viewModel.rootSignInViewModel)
            }
        }
        .tabItem {
            Image(systemName: "bookmark.fill")
            Text("Read Later")
        }
    }
    
    // MARK: - Init
    
    init(viewModel: PinViewModel) {
        self.viewModel = viewModel
    }
}
