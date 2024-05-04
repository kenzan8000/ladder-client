import SwiftUI

// MARK: - SignInPasswordTextFieldView

struct SignInPasswordTextFieldView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInPasswordTextFieldViewModel
    
    // MARK: - Public properties

    var body: some View {
        HStack {
            Spacer().frame(width: Spacing.default)
            
            SecureField(text: $viewModel.password) {
                Text("Password")
            }
            .keyboardType(.alphabet)
            .textContentType(.password)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .submitLabel(.done)
            .padding(Padding.textField)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.default)
                    .stroke(Color.secondary, lineWidth: 1)
            )

            Spacer().frame(width: Spacing.default)
        }
    }
}
