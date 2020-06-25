import SwiftUI

// MARK: - LDRFeedView
struct LDRFeedView: View {
    @ObservedObject var feedViewModel: LDRFeedViewModel
    @State var isPresentingLoginView = false
    @State var isPresentingDetailView = false
    
    var body: some View {
        NavigationView {
            VStack {
                picker()
                list()
                NavigationLink(
                    "LDRFeedDetailView",
                    destination: LDRFeedDetailView(),
                    isActive: $isPresentingDetailView
                )
            }
            .navigationBarTitle("RSS Feeds")
            .navigationBarItems(
                leading: loginButton(),
                trailing: reloadButton()
            )
            .sheet(isPresented: $isPresentingLoginView) {
                LDRLoginView(loginViewModel: LDRLoginViewModel())
            }
        }
        .onAppear {
            // self.feedViewModel.loadFeedFromLocalDB()
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
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .pickerStyle(SegmentedPickerStyle())
    }
    
    func list() -> some View {
        List {
            ForEach(feedViewModel.sections, id: \.self) { section in
                Section(header: Text(section)) {
                    ForEach(self.feedViewModel.getSubsUnreads(at: section)) { subsunread in
                        LDRFeedRow(
                            title: subsunread.title,
                            unreadCount: subsunread.unreadCountString,
                            color: self.feedViewModel.unreads[subsunread]?.state == LDRFeedUnread.State.unread ? Color.blue : Color.gray
                        ) {
                            self.isPresentingDetailView.toggle()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - LDRFeedView_Previews
struct LDRFeedView_Previews: PreviewProvider {
    static var previews: some View {
        LDRFeedView(feedViewModel: LDRFeedViewModel())
    }
}

// MARK: - LDRFeedViewController
class LDRFeedViewController: UIHostingController<LDRFeedView> {

    // MARK: - initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(
            coder: aDecoder,
            rootView: LDRFeedView(feedViewModel: LDRFeedViewModel())
        )
    }
}
