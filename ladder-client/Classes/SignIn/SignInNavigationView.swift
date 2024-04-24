import SwiftUI

// MARK: - SignInNavigationView

struct SignInNavigationView: View {
    // MARK: - Private properties

    @Environment(\.dismiss)
    private var dismiss

    // MARK: - Public properties

    var body: some View {
        NavigationView {
            SignInView()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(
                            action: { dismiss() },
                            label: { Image(systemName: "chevron.down") }
                        )
                    }
                }
        }
    }
}
