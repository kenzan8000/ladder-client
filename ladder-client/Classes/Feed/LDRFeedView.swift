import SwiftUI

// MARK: - LDRFeedView
struct LDRFeedView: View {
    @ObservedObject var feedViewModel: LDRFeedViewModel
    @State var isPresentingLoginView = false
    
    var body: some View {
        NavigationView {
            VStack {
                picker()
                list()
                navigationLink()
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
                            guard let unread = self.feedViewModel.unreads[subsunread] else {
                                return
                            }
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
        return AnyView(
            NavigationLink(
                "LDRFeedDetailView",
                destination: LDRFeedDetailView(feedDetailViewModel: LDRFeedDetailViewModel(unread: unread)),
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
