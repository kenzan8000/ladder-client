import SwiftUI

// MARK: - SignInUsernameTextFieldView

struct SignInUsernameTextFieldView: View {
    // MARK: - Private properties

    @State private var viewModel: SignInUsernameTextFieldViewModel

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
            .modifier(SignInTextFieldStateModifier(state: $viewModel.state))

            Spacer().frame(width: Spacing.default)
        }
    }
    
    // MARK: - Init
    
    init(viewModel: SignInUsernameTextFieldViewModel) {
        self.viewModel = viewModel
    }
}
