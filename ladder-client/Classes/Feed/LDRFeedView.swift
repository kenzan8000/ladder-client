import SwiftUI

// MARK: - LDRFeedView
struct LDRFeedView: View {
    @ObservedObject var feedViewModel: LDRFeedViewModel
    @State var isPresentingLoginView = false
    
    var body: some View {
        NavigationView {
            List(feedViewModel.subsunreads) { subsunread in
                Text("\(subsunread.title)")
            }
            .navigationBarItems(leading: navigationBar())
            .sheet(isPresented: $isPresentingLoginView) {
                LDRLoginView(loginViewModel: LDRLoginViewModel())
            }
        }
        .onAppear {
            self.feedViewModel.loadFeedFromLocalDB()
        }
    }
    
    func navigationBar() -> some View {
        HStack {
            self.loginButton()
            
            self.picker()
            
            self.reloadButton()
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
                self.feedViewModel.loadFeedFromAPI()
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
    
    func picker() -> some View {
        Picker(
            selection: $feedViewModel.segment,
            label: EmptyView()
        ) {
            Image(uiImage: IonIcons.image(
                withIcon: ion_ios_star,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ))
            .tag(LDRFeedSubsUnread.Segment.rate)
            Image(uiImage: IonIcons.image(
                withIcon: ion_ios_folder,
                iconColor: UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ))
            .tag(LDRFeedSubsUnread.Segment.folder)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

// MARK: - LDRFeedView_Previews
struct LDRFeedView_Previews: PreviewProvider {
    static var previews: some View {
        LDRFeedView(feedViewModel: LDRFeedViewModel())
    }
}

// MARK: - LDRPinViewController
class LDRFeedViewController: UIHostingController<LDRFeedView> {

    // MARK: - initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(
            coder: aDecoder,
            rootView: LDRFeedView(feedViewModel: LDRFeedViewModel())
        )
    }
}
