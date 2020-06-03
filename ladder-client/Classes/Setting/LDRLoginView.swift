import SwiftUI

struct LDRLoginView: View {
    @ObservedObject var loginViewModel: LDRLoginViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            self.urlDomainForm()
            Spacer()
                .frame(height: 10)
            self.usernamePasswordForm()
            Spacer()
                .frame(height: 10)
            self.loginButton()
        }
            .padding(16)
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
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField(
                "password",
                text: Binding<String>(
                    get: { self.loginViewModel.password },
                    set: { self.loginViewModel.update(password: $0) }
                )
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    func loginButton() -> some View {
        HStack {
            Button(
                action: { },
                label: { Text("Login") }
            )
                .frame(width: 112)
                .padding(8)
                .border(Color.blue)
        }
            .frame(maxWidth: .infinity)
    }
}

struct LDRLoginSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LDRLoginView(loginViewModel: LDRLoginViewModel())
    }
}
