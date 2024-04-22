import SwiftUI

// MARK: - PinView

struct PinView: View {
    // MARK: - Public properties

    var body: some View {
        NavigationView {
            VStack {
                Text("Read Later")
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
        .tabItem {
            Image(systemName: "pin.fill")
            Text("Read Later")
        }
    }
}
