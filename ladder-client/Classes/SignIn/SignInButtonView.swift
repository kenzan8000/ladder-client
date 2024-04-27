import SwiftUI

// MARK: - SignInButtonView

struct SignInButtonView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInButtonViewModel
    
    // MARK: - Public properties

    var body: some View {
        Button(
            action: { },
            label: {
                VStack {
                    Spacer().frame(height: Spacing.minimal)
                    HStack {
                        Spacer().frame(width: Spacing.double)
                        Text("Sign in")
                        Spacer().frame(width: Spacing.double)
                    }
                    Spacer().frame(height: Spacing.minimal)
                }
            }
        )
        .buttonStyle(BorderedProminentButtonStyle())
        .disabled(true)
    }
}
