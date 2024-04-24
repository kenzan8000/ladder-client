import SwiftUI

// MARK: - SignInUsernameTextFieldView

struct SignInUsernameTextFieldView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInUsernameTextFieldViewModel
    
    // MARK: - Public properties

    var body: some View {
        TextField("Username", text: $viewModel.username)
            .keyboardType(.alphabet)
            .textContentType(.username)
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .submitLabel(.next)
    }
}
