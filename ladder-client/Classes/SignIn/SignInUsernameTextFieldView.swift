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
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .submitLabel(.next)
            
            Spacer().frame(width: Spacing.default)
        }
    }
}
