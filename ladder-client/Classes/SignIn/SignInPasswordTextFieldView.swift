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
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .submitLabel(.send)
            
            Spacer().frame(width: Spacing.default)
        }
    }
}
