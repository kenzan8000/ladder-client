import SwiftUI

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
            .frame(alignment: .top)
            .navigationBarTitle("Login", displayMode: .inline)
            .navigationBarItems(trailing: dismissButton())
            .padding(16)
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
                action: { self.loginViewModel.startLogin() },
                label: {
                    if self.loginViewModel.isLogingingIn {
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
            if loginViewModel.isLogingingIn {
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

struct LDRLoginSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LDRLoginView(loginViewModel: LDRLoginViewModel())
    }
}

class LDRLoginViewController: UIHostingController<LDRLoginView> {

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
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
