import SwiftUI

// MARK: - PinView

struct PinView: View {
    // MARK: - Public enums
    
    enum ViewType {
        case signIn
        case list
    }
    
    // MARK: - Private properties
    
    @EnvironmentObject private var viewModel: PinViewModel

    // MARK: - Public properties

    var body: some View {
        RootNavigationView {
            /*
            RootSignInView()
                .environmentObject(viewModel.makeRootSignInViewModel())
            */
            PinListView()
                .environmentObject(viewModel.makePinListViewModel())
        }
        .tabItem {
            Image(systemName: "bookmark.fill")
            Text("Read Later")
        }
        .environmentObject(viewModel.makeRootNavigationViewModel())
    }
}
