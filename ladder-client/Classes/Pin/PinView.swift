import SwiftUI

// MARK: - PinView

struct PinView: View {
    // MARK: - Public enums
    
    enum ViewType {
        case signIn
        case list
    }
    
    // MARK: - Private properties
    
    @State private var viewModel: PinViewModel

    var body: some View {
        RootNavigationView(viewModel: viewModel.makeRootNavigationViewModel()) {
            if viewModel.isSignedIn {
                PinListView(viewModel: viewModel.makePinListViewModel())
            } else {
                RootSignInView(viewModel: viewModel.makeRootSignInViewModel())
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
