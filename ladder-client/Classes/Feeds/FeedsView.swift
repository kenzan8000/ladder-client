import SwiftUI

// MARK: - FeedsView

struct FeedsView: View {
    // MARK: - Public properties

    var body: some View {
        NavigationView {
            Text("Feeds")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            
                        },
                        label: {
                            VStack {
                                Image(systemName: "gearshape.fill")
                                Text("Settings")
                                    .font(.caption2)
                            }
                        }
                    )
                }
            }
        }
        .tabItem {
            Image(systemName: "wifi")
            Text("Feeds")
        }
    }
}
