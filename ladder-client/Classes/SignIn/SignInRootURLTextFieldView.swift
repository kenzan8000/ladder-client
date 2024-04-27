import SwiftUI

// MARK: - SignInDomainTextFieldView

struct SignInRootURLTextFieldView: View {
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInRootURLTextFieldViewModel
    
    // MARK: - Public properties

    var body: some View {
        HStack {
            Spacer().frame(width: Spacing.default)

            Text(viewModel.scheme)

            Spacer().frame(width: Spacing.tight)

            TextField(text: $viewModel.domainAndPath) {
                Text("Fastladder root URL")
            }
            .keyboardType(.URL)
            .textContentType(.URL)
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .submitLabel(.next)

            Spacer().frame(width: Spacing.default)
        }
    }
}
