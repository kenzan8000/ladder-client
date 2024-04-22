import SwiftUI

// MARK: - RootNavigationView

struct RootNavigationView: View {
    // MARK: - Public properties

    var body: some View {
        NavigationView {
            VStack {
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                        },
                        label: {
                            VStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Reload")
                                    .font(.caption2)
                            }
                        }
                    )
                }
            }
        }
    }
}
