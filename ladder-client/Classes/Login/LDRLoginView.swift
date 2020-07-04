import SwiftUI

// MARK: - LDRLoginView
struct LDRLoginView: View {
    // MARK: - property

    var dismiss: (() -> Void)?
    @ObservedObject var loginViewModel: LDRLoginViewModel
    
    // MARK: - view

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                self.urlDomainForm()
                Spacer().frame(height: 10)
                self.usernamePasswordForm()
                Spacer().frame(height: 10)
                self.loginButton()
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: 0, alignment: .bottom)
            .navigationBarTitle("Login", displayMode: .large)
            .padding(16)
        }
        .alert(isPresented: loginViewModel.isPresentingAlert) {
            var title = ""
            if let error = self.loginViewModel.error {
                title = error.localizedDescription
            }
            return Alert(title: Text(title))
        }
        .onDisappear {
            self.loginViewModel.endLogin()
        }
    }
    
    func urlDomainForm() -> some View {
        Group {
            Text("Your Fastladder URL:")
            HStack {
                Text("https://")
                .padding(6)
                .border(Color.gray)
                
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
        }
    }
    
    func usernamePasswordForm() -> some View {
        Group {
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
    }
    
    func loginButton() -> some View {
        HStack {
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
        .frame(maxWidth: .infinity)
    }
}

// MARK: - LDRLoginSettingView_Previews
struct LDRLoginSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LDRLoginView(loginViewModel: LDRLoginViewModel())
    }
}
