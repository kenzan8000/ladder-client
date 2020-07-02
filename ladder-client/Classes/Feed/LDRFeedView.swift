import Introspect
import SwiftUI

// MARK: - LDRFeedView
struct LDRFeedView: View {
    @ObservedObject var feedViewModel: LDRFeedViewModel
    @State var tabBar: UITabBar?
    
    var body: some View {
        NavigationView {
            VStack {
                list()
                navigationLink()
            }
            .navigationBarTitle("\(feedViewModel.unreadCount) Updates")
            .navigationBarItems(
                leading: loginButton(),
                trailing: reloadButton()
            )
            .sheet(isPresented: $feedViewModel.isPresentingLoginView) {
                LDRLoginView(loginViewModel: LDRLoginViewModel())
            }
        }
        .onAppear {
            self.feedViewModel.loadFeedFromLocalDB()
            self.tabBar?.isHidden = false
        }
        .introspectViewController { viewController in
            self.tabBar = viewController.tabBarController?.tabBar
            self.tabBar?.isHidden = false
        }
    }
    
    func loginButton() -> some View {
        Button(
            action: {
                self.feedViewModel.isPresentingLoginView.toggle()
            },
            label: {
                Image(uiImage: IonIcons.image(
                    withIcon: ion_log_in,
                    iconColor: UIColor.systemBlue,
                    iconSize: 32,
                    imageSize: CGSize(width: 32, height: 32)
                ))
                Text("Login")
                .foregroundColor(Color.blue)
            }
        )
    }
    
    func reloadButton() -> some View {
        Button(
            action: {
                self.feedViewModel.loadFeedFromAPI()
            },
            label: {
                Text("Reload")
                .foregroundColor(Color.blue)
                Image(uiImage: IonIcons.image(
                    withIcon: ion_android_refresh,
                    iconColor: UIColor.systemBlue,
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
                iconColor: feedViewModel.segment == LDRFeedSubsUnread.Segment.rate ? UIColor.systemBlue : UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ))
            .tag(LDRFeedSubsUnread.Segment.rate)
            Image(uiImage: IonIcons.image(
                withIcon: ion_ios_folder,
                iconColor: feedViewModel.segment == LDRFeedSubsUnread.Segment.folder ? UIColor.systemBlue : UIColor.systemGray,
                iconSize: 32,
                imageSize: CGSize(width: 32, height: 32)
            ))
            .tag(LDRFeedSubsUnread.Segment.folder)
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .pickerStyle(SegmentedPickerStyle())
        .animation(nil)
        .disabled(feedViewModel.isLoading)
    }
    
    func list() -> some View {
        List {
            picker()
            ForEach(feedViewModel.sections, id: \.self) { section in
                Section(header: Text(section)) {
                    ForEach(self.feedViewModel.getSubsUnreads(at: section)) { subsunread in
                        LDRFeedRow(
                            title: subsunread.title,
                            unreadCount: self.feedViewModel.unreads[subsunread]?.state != LDRFeedUnread.State.read ? subsunread.unreadCountString : "",
                            color: self.feedViewModel.unreads[subsunread]?.state == LDRFeedUnread.State.unread ? Color.blue : Color.gray
                        ) {
                            guard let unread = self.feedViewModel.unreads[subsunread] else {
                                return
                            }
                            self.feedViewModel.touchAll(unread: unread)
                            self.feedViewModel.selectUnread(unread: unread)
                        }
                    }
                }
            }
        }
    }
    
    func navigationLink() -> some View {
        guard let unread = feedViewModel.unread else {
            return AnyView(EmptyView())
        }
        let feedDetailView = LDRFeedDetailView(
            feedDetailViewModel: LDRFeedDetailViewModel(unread: unread),
            feedDetailWebViewModel: LDRFeedDetailWebViewModel()
        )
        return AnyView(
            NavigationLink(
                "LDRFeedDetailView",
                destination: feedDetailView,
                isActive: feedViewModel.isPresentingDetailView
            )
        )
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
