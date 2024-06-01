import SwiftUI

// MARK: - SignInPasswordTextFieldView

struct SignInPasswordTextFieldView: View {
    // MARK: - Private properties

    @State private var viewModel: SignInPasswordTextFieldViewModel
    
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
            .modifier(SignInTextFieldStateModifier(state: $viewModel.state))

            Spacer().frame(width: Spacing.default)
        }
    }
    
    // MARK: - Init
    
    init(viewModel: SignInPasswordTextFieldViewModel) {
        self.viewModel = viewModel
    }
}
