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
    
    @Environment(\.dismiss)
    private var dismiss

    @EnvironmentObject private var viewModel: SignInViewModel

    @FocusState private var focusedField: SignInView.Field?
    
    // MARK: - Public properties

    var body: some View {
        VStack {
            Spacer().frame(height: Spacing.default)
            SignInRootURLTextFieldView()
                .environmentObject(viewModel.rootURLTextFieldViewModel)
                .focused($focusedField, equals: .rootURL)
                .onSubmit { focusedField = .username }
            Spacer().frame(height: Spacing.small)
            SignInUsernameTextFieldView()
                .environmentObject(viewModel.usernameTextFieldViewModel)
                .focused($focusedField, equals: .username)
                .onSubmit { focusedField = .password }
            Spacer().frame(height: Spacing.small)
            SignInPasswordTextFieldView()
                .environmentObject(viewModel.passwordTextFieldViewModel)
                .focused($focusedField, equals: .password)
                .onSubmit { signInIfNeeded() }
            Spacer().frame(height: Spacing.double)
            SignInButtonView { signInIfNeeded() }
                .environmentObject(viewModel.signInButtonViewModel)
            Spacer().frame(height: Spacing.default)
            SignInDividerView()
            Spacer().frame(height: Spacing.small)
            SignUpLinkView()
                .environmentObject(viewModel.signUpLinkViewModel)
            Spacer()
        }
        .padding(.horizontal)
        .onAppear { focusedField = viewModel.nextFocusedField }
        .onDisappear { viewModel.cancelSigningIn() }
        .onChange(of: focusedField) { viewModel.updateState(focusedField: focusedField) }
        .modifier(ViewAlertModifier(publisher: viewModel.$error.eraseToAnyPublisher()))
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
