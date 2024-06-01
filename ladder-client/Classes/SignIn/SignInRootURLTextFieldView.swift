import Combine
import SwiftUI

// MARK: - SignInDomainTextFieldView

struct SignInRootURLTextFieldView: View {
    // MARK: - Private properties

    @State private var viewModel: SignInRootURLTextFieldViewModel
    
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
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .padding(Padding.textField)
            .modifier(SignInTextFieldStateModifier(state: $viewModel.state))

            Spacer().frame(width: Spacing.default)
        }
    }
    
    // MARK: - Init
    
    init(viewModel: SignInRootURLTextFieldViewModel) {
        self.viewModel = viewModel
    }
}
