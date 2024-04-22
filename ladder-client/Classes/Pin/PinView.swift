import SwiftUI

// MARK: - PinView

struct PinView: View {
    // MARK: - Public properties

    var body: some View {
        RootNavigationView()
            .tabItem {
                Image(systemName: "pin.fill")
                Text("Read Later")
            }
    }
}
