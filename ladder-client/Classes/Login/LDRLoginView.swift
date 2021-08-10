import KeychainAccess
import SwiftUI

// MARK: - LDRLoginView
struct LDRLoginView: View {
  // MARK: property

  let keychain: LDRKeychain
  @EnvironmentObject var viewModel: ViewModel

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
        .allowsHitTesting(!viewModel.isLogingIn)
        .onReceive(viewModel.allValidation) { validation in
          viewModel.loginDisabled = !validation.isSuccess
        }
    }
    .alert(isPresented: viewModel.isPresentingAlert) {
      Alert(title: Text(viewModel.error?.legibleDescription ?? ""))
    }
    .onAppear {
      viewModel.urlDomain = keychain.ldrUrlString ?? ""
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
      action: { viewModel.login() },
      label: {
        HStack {
          Text("Login")
            .foregroundColor(
              viewModel.loginDisabled || viewModel.isLogingIn ?
                .secondary : .blue
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
