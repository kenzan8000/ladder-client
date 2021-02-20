import Introspect
import SwiftUI

// MARK: - LDRFeedView
struct LDRFeedView: View {
    // MARK: - property

    @ObservedObject var feedViewModel: LDRFeedViewModel
    @StateObject var loginViewModel: LDRLoginViewModel
    @State var tabBar: UITabBar?

    // MARK: - view

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
              LDRLoginView().environmentObject(loginViewModel)
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
                Image(systemName: "person.circle")
                .foregroundColor(.blue)
                Text("Login")
                .foregroundColor(.blue)
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
                .foregroundColor(.blue)
                Image(systemName: "arrow.clockwise")
                .foregroundColor(.blue)
            }
        )
    }
    
    func picker() -> some View {
        Picker(
            selection: $feedViewModel.segment,
            label: EmptyView()
        ) {
            Image(systemName: "star.fill")
            .foregroundColor(feedViewModel.segment == .rate ? .blue : .gray)
            .tag(LDRFeedSubsUnread.Segment.rate)
            Image(systemName: "folder.fill")
            .foregroundColor(feedViewModel.segment == .folder ? .blue : .gray)
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
                            color: self.feedViewModel.unreads[subsunread]?.state == LDRFeedUnread.State.unread ? .blue : .gray
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
        .listStyle(PlainListStyle())
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
        LDRFeedView(feedViewModel: LDRFeedViewModel(), loginViewModel: LDRLoginViewModel())
    }
}
