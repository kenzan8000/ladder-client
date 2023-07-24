import KeychainAccess
import SwiftUI

// MARK: - LDRLoginView
struct LDRLoginView: View {
    // MARK: enum
    enum FocusedField: Hashable {
        case urlDomain
        case username
        case password
    }

    // MARK: property

    let keychain: LDRKeychain
    @EnvironmentObject var viewModel: ViewModel
    @FocusState var focusedForm: FocusedField?

    // MARK: view

    var body: some View {
        NavigationView {
            Form {
                urlDomainTextField
                usernameTextField
                passwordTextField
                loginButton
            }
                .navigationViewStyle(.stack)
                .navigationBarTitle("Login", displayMode: .large)
                .navigationBarItems(leading: closeButton)
                .disabled(viewModel.isLogingIn)
                .onReceive(viewModel.allValidation) { validation in
                    viewModel.loginDisabled = !validation.isSuccess
                }
        }
        .alert(item: $viewModel.alertToShow) {
            Alert(
                title: Text($0.title),
                message: Text($0.message),
                dismissButton: .default(Text($0.buttonText))
            )
        }
        .onAppear {
            viewModel.urlDomain = keychain.ldrUrlString ?? ""
            focusedForm = viewModel.urlDomain.isEmpty ? .urlDomain : .username
        }
    }

    var urlDomainTextField: some View {
        HStack {
            Text("https://")
                .padding(6)
                .border(Color.secondary)
            TextField(
                "Your Fastladder URL",
                text: $viewModel.urlDomain
            )
                .validation(loginFormValidationPublisher: viewModel.urlDomainValidation)
                .keyboardType(.URL)
                .textContentType(.URL)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusedForm, equals: .urlDomain)
                .submitLabel(.next)
                .onSubmit { focusedForm = .username }
        }
    }

    var usernameTextField: some View {
        TextField(
            "username",
            text: $viewModel.username
        )
            .validation(loginFormValidationPublisher: viewModel.usernameValidation)
            .keyboardType(.alphabet)
            .textContentType(.username)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .focused($focusedForm, equals: .username)
            .submitLabel(.next)
            .onSubmit { focusedForm = .password }
    }
        
    var passwordTextField: some View {
        SecureField(
            "password",
            text: $viewModel.password
        )
            .validation(loginFormValidationPublisher: viewModel.passwordValidation)
            .keyboardType(.alphabet)
            .textContentType(.password)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .focused($focusedForm, equals: .password)
            .submitLabel(.send)
            .onSubmit {
                if viewModel.canLogin {
                    viewModel.login()
                }
                focusedForm = nil
            }
    }
        
    var closeButton: some View {
        Button(
            action: {
                viewModel.tearDown()
                NotificationCenter.default.post(name: .ldrWillCloseLoginView, object: nil)
            },
            label: {
                Image(systemName: "xmark")
                    .foregroundColor(.blue)
            }
        )
    }
        
    var loginButton: some View {
        Button(
            action: {
                viewModel.login()
                focusedForm = nil
            },
            label: {
                HStack {
                    Text("Login")
                        .foregroundColor(
                            viewModel.canLogin ? .blue : .secondary
                        )
                    if viewModel.isLogingIn {
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    }
                }
            }
        )
        .disabled(viewModel.loginDisabled)
    }
}

// MARK: - LDRLoginView_Previews
struct LDRLoginSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let keychain = LDRKeychainStore(service: LDR.service, group: LDR.group)
        ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
            LDRLoginView(keychain: keychain).environmentObject(LDRLoginView.ViewModel(keychain: keychain))
                .colorScheme($0)
        }
    }
}
