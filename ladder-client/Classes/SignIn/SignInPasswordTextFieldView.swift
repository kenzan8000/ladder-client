import SwiftUI

// MARK: - SignInPasswordTextFieldView

struct SignInPasswordTextFieldView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInPasswordTextFieldViewModel
    
    // MARK: - Public properties

    var body: some View {
        TextField("Password", text: $viewModel.password)
            .keyboardType(.alphabet)
            .textContentType(.password)
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .submitLabel(.send)
    }
}
