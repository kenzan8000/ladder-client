import SwiftUI

// MARK: - FeedView

struct FeedView: View {
    // MARK: - Public properties

    var body: some View {
        RootNavigationView {
            Text("Feeds")
        }
        .tabItem {
            Image(systemName: "wifi")
            Text("Feeds")
        }
    }
}
