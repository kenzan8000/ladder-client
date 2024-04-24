import SwiftUI

// MARK: - SignInDomainTextFieldView

struct SignInDomainTextFieldView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInDomainTextFieldViewModel
    
    // MARK: - Public properties

    var body: some View {
        HStack {
            Text("https://")
            TextField("Fastladder root URL", text: $viewModel.domainAndPath)
                .keyboardType(.URL)
                .textContentType(.URL)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .submitLabel(.next)
        }
    }
}
