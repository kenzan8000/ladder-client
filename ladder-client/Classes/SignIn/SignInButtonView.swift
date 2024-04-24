import SwiftUI

// MARK: - SignInButtonView

struct SignInButtonView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInButtonViewModel
    
    // MARK: - Public properties

    var body: some View {
        Button(
            action: { },
            label: { Text("Sign in") }
        )
    }
}
