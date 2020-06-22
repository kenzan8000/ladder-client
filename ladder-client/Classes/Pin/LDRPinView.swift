import SwiftUI

// MARK: - LDRPinView
struct LDRPinView: View {
    @ObservedObject var pinViewModel: LDRPinViewModel

    init(pinViewModel: LDRPinViewModel) {
        self.pinViewModel = pinViewModel
        self.pinViewModel.reload()
    }
    
    var body: some View {
        NavigationView {
            List(pinViewModel.pins) { pin in
                LDRPinRow(title: pin.title)
            }
            .navigationBarTitle("\(pinViewModel.pins.count) pins", displayMode: .large)
            .navigationBarItems(
                leading: reloadButton(),
                trailing: loginButton()
            )
        }
    }
    
    func reloadButton() -> some View {
        Button(
            action: {
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
    
    func loginButton() -> some View {
        Button(
            action: {
            },
            label: {
                Image(uiImage: IonIcons.image(
                    withIcon: ion_person,
                    iconColor: UIColor.systemGray,
                    iconSize: 32,
                    imageSize: CGSize(width: 32, height: 32)
                ))
            }
        )
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
