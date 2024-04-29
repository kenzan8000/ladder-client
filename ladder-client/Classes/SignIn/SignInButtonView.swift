import SwiftUI

// MARK: - SignInButtonView

struct SignInButtonView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInButtonViewModel
    
    private let action: () -> Void
    
    // MARK: - Public properties

    var body: some View {
        Button(action: action) {
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
        .buttonStyle(BorderedButtonStyle())
    }
    
    // MARK: - Init
    
    init(action: @escaping () -> Void) {
        self.action = action
    }

}
