import SwiftUI

// MARK: - SignInUsernameTextFieldView

struct SignInUsernameTextFieldView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInUsernameTextFieldViewModel

    // MARK: - Public properties

    var body: some View {
        HStack {
            Spacer().frame(width: Spacing.default)
            
            TextField(text: $viewModel.username) {
                Text("Username")
            }
            .keyboardType(.alphabet)
            .textContentType(.username)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .padding(Padding.textField)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.default)
                    .stroke(Color.secondary, lineWidth: 1)
            )

            Spacer().frame(width: Spacing.default)
        }
    }
}
