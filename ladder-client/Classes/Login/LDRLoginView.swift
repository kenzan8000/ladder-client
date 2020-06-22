import SwiftUI

// MARK: - LDRLoginView
struct LDRLoginView: View {
    var dismiss: (() -> Void)?
    @ObservedObject var loginViewModel: LDRLoginViewModel

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
            .navigationBarItems(trailing: dismissButton())
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
    
    func dismissButton() -> some View {
        Group {
            if !loginViewModel.isLogingIn {
                Button(
                    action: {
                        if let dismiss = self.dismiss {
                            dismiss()
                        }
                    },
                    label: {
                        Image(uiImage: IonIcons.image(
                            withIcon: ion_android_close,
                            iconColor: UIColor.systemGray,
                            iconSize: 32,
                            imageSize: CGSize(width: 32, height: 32)
                        ))
                    }
                )
            }
        }
    }
}

// MARK: - LDRLoginSettingView_Previews
struct LDRLoginSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LDRLoginView(loginViewModel: LDRLoginViewModel())
    }
}

// MARK: - LDRLoginViewController
class LDRLoginViewController: UIHostingController<LDRLoginView> {

    // MARK: - initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(
            coder: aDecoder,
            rootView: LDRLoginView(loginViewModel: LDRLoginViewModel())
        )
        rootView.dismiss = dismiss
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LDRLoginViewController.didLogin),
            name: LDRNotificationCenter.didLogin,
            object: nil
        )
    }
    
    // MARK: - destruction

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - notification

    /// called when did login
    ///
    /// - Parameter notification: notification happened when user did login
    @objc
    func didLogin(notification: NSNotification) {
        DispatchQueue.main.async { [unowned self] in
            self.dismiss()
        }
    }
    
    /// dismiss view controller
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
