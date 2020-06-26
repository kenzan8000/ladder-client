import SwiftUI

// MARK: - LDRPinView
struct LDRPinView: View {
    @ObservedObject var pinViewModel: LDRPinViewModel
    @State var isPresentingLoginView = false
    
    var body: some View {
        NavigationView {
            self.list()
        }
        .onAppear {
            // self.pinViewModel.loadPinsFromLocalDB()
        }
        .sheet(isPresented: pinViewModel.isPresentingSafariView) {
            self.safariView()
        }
        .alert(isPresented: pinViewModel.isPresentingAlert) {
            var title = ""
            if let error = self.pinViewModel.error {
                title = error.localizedDescription
            }
            return Alert(title: Text(title))
        }
    }
    
    func loginButton() -> some View {
        Button(
            action: {
                self.isPresentingLoginView.toggle()
            },
            label: {
                Image(uiImage: IonIcons.image(
                    withIcon: ion_log_in,
                    iconColor: UIColor.systemGray,
                    iconSize: 32,
                    imageSize: CGSize(width: 32, height: 32)
                ))
            }
        )
    }
    
    func reloadButton() -> some View {
        Button(
            action: {
                self.pinViewModel.loadPinsFromAPI()
            },
            label: {
                Image(uiImage: IonIcons.image(
                    withIcon: ion_android_refresh,
                    iconColor: UIColor.systemGray,
                    iconSize: 32,
                    imageSize: CGSize(width: 32, height: 32)
                ))
            }
        )
    }
    
    func list() -> some View {
        List(pinViewModel.pins) { pin in
            LDRPinRow(title: pin.title) {
                self.pinViewModel.delete(pin: pin)
            }
        }
        .navigationBarTitle("\(pinViewModel.pins.count) Pins", displayMode: .large)
        .navigationBarItems(
            leading: loginButton(),
            trailing: reloadButton()
        )
        .sheet(isPresented: $isPresentingLoginView) {
            LDRLoginView(loginViewModel: LDRLoginViewModel())
        }
    }
    
    func safariView() -> some View {
        guard let url = self.pinViewModel.safariUrl else {
            return AnyView(EmptyView())
        }
        return AnyView(SafariView(url: url))
    }
}

// MARK: - LDRPinView_Previews
struct LDRPinView_Previews: PreviewProvider {
    static var previews: some View {
        LDRPinView(pinViewModel: LDRPinViewModel())
    }
}

// MARK: - LDRPinViewController
class LDRPinViewController: UIHostingController<LDRPinView> {

    // MARK: - initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(
            coder: aDecoder,
            rootView: LDRPinView(pinViewModel: LDRPinViewModel())
        )
    }
}
