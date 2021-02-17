import SwiftUI

// MARK: - LDRLoginView
struct LDRLoginView: View {
    // MARK: - property

    var dismiss: (() -> Void)?
    @EnvironmentObject var loginViewModel: LDRLoginViewModel
    
    internal var didAppear: ((Self) -> Void)?
    
    // MARK: - view

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                urlDomainForm
                Spacer().frame(height: 10)
                usernameAndPasswordForm
                Spacer().frame(height: 10)
                HStack {
                    loginButton
                }
                .frame(maxWidth: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: 0, alignment: .bottom)
            .navigationBarTitle("Login", displayMode: .large)
            .navigationBarItems(leading: closeButton)
            .padding(16)
        }
        .alert(isPresented: loginViewModel.isPresentingAlert) {
            var title = ""
            if let error = self.loginViewModel.error {
                title = error.localizedDescription
            }
            return Alert(title: Text(title))
        }
        .onAppear {
            self.didAppear?(self)
        }
        .onDisappear {
            self.loginViewModel.endLogin()
        }
    }
    
    var urlDomainForm: some View {
        Group {
            Text("Your Fastladder URL:")
            HStack {
                Text("https://")
                .padding(6)
                .border(Color.gray)
                
                urlDomainTextField
            }
        }
    }
    
    var urlDomainTextField: some View {
        TextField(
            "",
            text: Binding<String>(
                get: { self.loginViewModel.urlDomain },
                set: { self.loginViewModel.update(domainUrl: $0) }
            )
        )
        .keyboardType(.URL)
        .textContentType(.URL)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    var usernameAndPasswordForm: some View {
        Group {
            usernameTextField
            passwordTextField
        }
    }
    
    var usernameTextField: some View {
        TextField(
            "username",
            text: Binding<String>(
                get: { self.loginViewModel.username },
                set: { self.loginViewModel.update(username: $0) }
            )
        )
        .keyboardType(.alphabet)
        .textContentType(.username)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    var passwordTextField: some View {
        SecureField(
            "password",
            text: Binding<String>(
                get: { self.loginViewModel.password },
                set: { self.loginViewModel.update(password: $0) }
            )
        )
        .textContentType(.password)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    var closeButton: some View {
        Button(
            action: {
                NotificationCenter.default.post(name: LDRNotificationCenter.willCloseLoginView, object: nil)
            },
            label: {
                Image(systemName: "xmark")
                .foregroundColor(.blue)
            }
        )
    }
    
    var loginButton: some View {
        Button(
            action: { self.loginViewModel.startLogin() },
            label: {
                if self.loginViewModel.isLogingIn {
                    ActivityIndicator(
                        isAnimating: .constant(true),
                        style: .medium
                    )
                } else {
                    Text("Login")
                }
            }
        )
        .frame(width: 112)
        .padding(8)
        .border(Color.blue)
    }
}

// MARK: - LDRLoginSettingView_Previews
struct LDRLoginSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LDRLoginView().environmentObject(LDRLoginViewModel())
    }
}
