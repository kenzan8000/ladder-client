import SwiftUI

// MARK: - PinView

struct PinView: View {
    // MARK: - Private properties
    
    @EnvironmentObject private var viewModel: PinViewModel

    // MARK: - Public properties

    var body: some View {
        RootNavigationView {
            Text("Read Later")
        }
        .tabItem {
            Image(systemName: "bookmark.fill")
            Text("Read Later")
        }
        .environmentObject(viewModel.makeRootNavigationViewModel())
    }
}
