import SwiftUI

// MARK: - PinView

struct PinView: View {
    // MARK: - Public properties

    var body: some View {
        RootNavigationView {
            Text("Read Later")
        }
        .tabItem {
            Image(systemName: "pin.fill")
            Text("Read Later")
        }
    }
}
