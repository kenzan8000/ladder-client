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
    
    @State private var isSignedIn = false

    var body: some View {
        RootNavigationView {
            if isSignedIn {
                PinListView()
                    .environmentObject(viewModel.makePinListViewModel())
                    .onReceive(viewModel.isSignedInPublisher) { isSignedIn = $0 }
            } else {
                RootSignInView()
                    .environmentObject(viewModel.makeRootSignInViewModel())
                    .onReceive(viewModel.isSignedInPublisher) { isSignedIn = $0 }
            }
        }
        .tabItem {
            Image(systemName: "bookmark.fill")
            Text("Read Later")
        }
        .environmentObject(viewModel.makeRootNavigationViewModel())
    }
}
