import SwiftUI

// MARK: - LDRLoginView
struct LDRLoginView: View {
  // MARK: - property

  @EnvironmentObject var loginViewModel: LDRLoginViewModel

  // MARK: - view

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
    }
    .alert(isPresented: loginViewModel.isPresentingAlert) {
      Alert(title: Text(loginViewModel.error?.localizedDescription ?? ""))
    }
  }

  var urlDomainTextField: some View {
    HStack {
      Text("https://")
        .padding(6)
        .border(Color.gray)
      TextField(
        "Your Fastladder URL",
        text: $loginViewModel.urlDomain
      )
        .keyboardType(.URL)
        .textContentType(.URL)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
  }

  var usernameTextField: some View {
    TextField(
      "username",
      text: $loginViewModel.username
    )
      .keyboardType(.alphabet)
      .textContentType(.username)
  }
    
  var passwordTextField: some View {
    SecureField(
      "password",
      text: $loginViewModel.password
    )
      .keyboardType(.alphabet)
      .textContentType(.password)
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
      action: { loginViewModel.login() },
      label: {
        HStack {
          Text("Login")
            .foregroundColor(
              loginViewModel.isLogingIn ? .secondary : .blue
            )
          if loginViewModel.isLogingIn {
            ActivityIndicator(isAnimating: .constant(true), style: .medium)
          }
        }
      }
    )
  }
}

// MARK: - LDRLoginView_Previews
struct LDRLoginSettingView_Previews: PreviewProvider {
  static var previews: some View {
    LDRLoginView().environmentObject(LDRLoginViewModel())
  }
}
