import SwiftUI

// MARK: - LDRFeedView
struct LDRFeedView: View {
    // @ObservedObject var feedViewModel: LDRFeedViewModel
    @State var isPresentingLoginView = false
    
    var body: some View {
        NavigationView {
            List {
                Text("Test")
            }
            .navigationBarItems(
                leading: loginButton(),
                trailing: reloadButton()
            )
            .sheet(isPresented: $isPresentingLoginView) {
                LDRLoginView(loginViewModel: LDRLoginViewModel())
            }
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
                // self.feedViewModel.loadPinsFromAPI()
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
}

// MARK: - LDRFeedView_Previews
struct LDRFeedView_Previews: PreviewProvider {
    static var previews: some View {
        LDRFeedView()
    }
}

// MARK: - LDRPinViewController
class LDRFeedViewController: UIHostingController<LDRFeedView> {

    // MARK: - initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(
            coder: aDecoder,
            rootView: LDRFeedView()
        )
    }
}
