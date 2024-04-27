import SwiftUI

// MARK: - FeedView

struct FeedView: View {
    // MARK: - Public properties

    var body: some View {
        RootNavigationView {
            Text("RSS Feeds")
        }
        .tabItem {
            Image(systemName: "wifi")
            Text("RSS Feeds")
        }
    }
}
