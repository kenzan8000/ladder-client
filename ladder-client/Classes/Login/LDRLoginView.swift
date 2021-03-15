import KeychainAccess
import SwiftUI

// MARK: - LDRLoginView
struct LDRLoginView: View {
  // MARK: property

  @EnvironmentObject var loginViewModel: LDRLoginViewModel

  // MARK: view

  var body: some View {
    NavigationView {
      Form {
        urlDomainTextField
        usernameTextField
        passwordTextField
        loginButton
      }
        .navigationBarTitle("Login", displayMode: .large)
        .navigationBarItems(leading: closeButton)
        .allowsHitTesting(!loginViewModel.isLogingIn)
        .onReceive(loginViewModel.allValidation) { validation in
          loginViewModel.loginDisabled = !validation.isSuccess
        }
    }
    .alert(isPresented: loginViewModel.isPresentingAlert) {
      Alert(title: Text(loginViewModel.error?.legibleDescription ?? ""))
    }
    .onAppear {
      loginViewModel.urlDomain = Keychain.ldr[LDRKeychain.ldrUrlString] ?? ""
    }
  }

  var urlDomainTextField: some View {
    HStack {
      Text("https://")
        .padding(6)
        .border(Color.secondary)
      TextField(
        "Your Fastladder URL",
        text: $loginViewModel.urlDomain
      )
        .validation(loginFormValidationPublisher: loginViewModel.urlDomainValidation)
        .keyboardType(.URL)
        .textContentType(.URL)
        .autocapitalization(.none)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
  }

  var usernameTextField: some View {
    TextField(
      "username",
      text: $loginViewModel.username
    )
      .validation(loginFormValidationPublisher: loginViewModel.usernameValidation)
      .keyboardType(.alphabet)
      .textContentType(.username)
      .autocapitalization(.none)
  }
    
  var passwordTextField: some View {
    SecureField(
      "password",
      text: $loginViewModel.password
    )
      .validation(loginFormValidationPublisher: loginViewModel.passwordValidation)
      .keyboardType(.alphabet)
      .textContentType(.password)
      .autocapitalization(.none)
  }
    
  var closeButton: some View {
    Button(
      action: {
        loginViewModel.tearDown()
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
      action: { loginViewModel.login() },
      label: {
        HStack {
          Text("Login")
            .foregroundColor(
              loginViewModel.loginDisabled || loginViewModel.isLogingIn ?
                .secondary : .blue
            )
          if loginViewModel.isLogingIn {
            ActivityIndicator(isAnimating: .constant(true), style: .medium)
          }
        }
      }
    )
    .disabled(loginViewModel.loginDisabled)
  }
}

// MARK: - LDRLoginView_Previews
struct LDRLoginSettingView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      LDRLoginView().environmentObject(LDRLoginViewModel())
        .colorScheme($0)
    }
  }
}
