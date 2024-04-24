import SwiftUI

// MARK: - SignInDomainTextFieldView

struct SignInDomainTextFieldView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInDomainTextFieldViewModel
    
    // MARK: - Public properties

    var body: some View {
        HStack {
            Text("https://")
            TextField("Fastladder root URL", text: $viewModel.rootURL)
                .keyboardType(.URL)
                .textContentType(.URL)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .submitLabel(.next)
        }
    }
}
