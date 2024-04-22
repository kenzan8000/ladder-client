import SwiftUI

// MARK: - FeedView

struct FeedView: View {
    // MARK: - Public properties

    var body: some View {
        RootNavigationView()
            .tabItem {
                Image(systemName: "wifi")
                Text("Feeds")
            }
    }
}
