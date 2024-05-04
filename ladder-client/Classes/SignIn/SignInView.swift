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
                .environmentObject(viewModel.buttonViewModel)
            Spacer()
        }
        .padding(.horizontal)
        .onAppear { focusedField = viewModel.nextFocusedField }
        .onDisappear { viewModel.cancelSigningIn() }
    }
    
    // MARK: - Public methods
    
    func signInIfNeeded() {
        guard viewModel.isFormValid else {
            focusedField = viewModel.nextFocusedField
            return
        }
        viewModel.signIn()
    }
}
