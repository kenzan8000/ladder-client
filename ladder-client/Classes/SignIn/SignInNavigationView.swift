import SwiftUI

// MARK: - SignInNavigationView

struct SignInNavigationView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInNavigationViewModel

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
                .environmentObject(viewModel.makeSignInViewModel())
        }
    }
}
