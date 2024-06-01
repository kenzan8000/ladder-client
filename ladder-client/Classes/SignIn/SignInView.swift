import SwiftUI

// MARK: - SignInView

struct SignInView: View {
    // MARK: - Public enums
    
    enum Field: Hashable {
        case rootURL
        case username
        case password
    }

    // MARK: - Private properties
    
    @State private var viewModel: SignInViewModel

    @Environment(\.dismiss)
    private var dismiss

    @FocusState private var focusedField: SignInView.Field?
    
    // MARK: - Public properties

    var body: some View {
        VStack {
            Spacer().frame(height: Spacing.default)
            SignInRootURLTextFieldView(viewModel: viewModel.rootURLTextFieldViewModel)
                .focused($focusedField, equals: .rootURL)
                .onSubmit { focusedField = .username }
            Spacer().frame(height: Spacing.small)
            SignInUsernameTextFieldView(viewModel: viewModel.usernameTextFieldViewModel)
                .focused($focusedField, equals: .username)
                .onSubmit { focusedField = .password }
            Spacer().frame(height: Spacing.small)
            SignInPasswordTextFieldView(viewModel: viewModel.passwordTextFieldViewModel)
                .focused($focusedField, equals: .password)
                .onSubmit { signInIfNeeded() }
            Spacer().frame(height: Spacing.double)
            SignInButtonView(viewModel: viewModel.signInButtonViewModel) { signInIfNeeded() }
            Spacer().frame(height: Spacing.small)
            SignInDividerView()
            Spacer().frame(height: Spacing.tight)
            SignUpLinkView(viewModel: viewModel.signUpLinkViewModel)
            Spacer()
        }
        .padding(.horizontal)
        .onAppear { focusedField = viewModel.nextFocusedField }
        .onDisappear { viewModel.cancelSigningIn() }
        .onChange(of: focusedField) { viewModel.updateState(focusedField: focusedField) }
        .modifier(ViewAlertModifier(error: viewModel.error))
    }
    
    // MARK: - Init
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Public methods
    
    func signInIfNeeded() {
        viewModel.hasAttemptedSigningIn = true
        focusedField = viewModel.nextFocusedField
        viewModel.updateState(focusedField: focusedField)
        Task { @MainActor in
            guard await self.viewModel.signIn() else {
                return
            }
            dismiss()
        }
    }
}
