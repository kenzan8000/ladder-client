import SwiftUI

// MARK: - LDRFeedView
struct LDRFeedView: View {
  // MARK: property

  @ObservedObject var feedViewModel: LDRFeedViewModel
  @EnvironmentObject var loginViewModel: LDRLoginViewModel

  // MARK: property

  var body: some View {
    NavigationView {
      VStack {
        list
        navigationLink
      }
      .navigationBarTitle("\(feedViewModel.unreadCount) Updates")
      .navigationBarItems(leading: loginButton, trailing: reloadButton)
      .sheet(isPresented: $feedViewModel.isPresentingLoginView) {
        LDRLoginView()
      }
    }
    .alert(isPresented: feedViewModel.isPresentingAlert) {
      Alert(title: Text(feedViewModel.error?.localizedDescription ?? ""))
    }
    .onAppear {
      feedViewModel.loadFeedFromLocalDB()
    }
  }
    
  var loginButton: some View {
    Button(
      action: { feedViewModel.isPresentingLoginView.toggle() },
      label: {
        Image(systemName: "person.circle")
          .foregroundColor(.blue)
        Text("Login")
          .foregroundColor(.blue)
      }
    )
  }
    
  var reloadButton: some View {
    Button(
      action: {
        feedViewModel.loadFeedFromAPI()
      },
      label: {
        Text("Reload")
          .foregroundColor(.blue)
        Image(systemName: "arrow.clockwise")
          .foregroundColor(.blue)
      }
    )
  }
    
  var picker: some View {
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
    
  var list: some View {
    List {
      picker
      ForEach(feedViewModel.sections, id: \.self) { section in
        Section(header: Text(section)) {
          ForEach(feedViewModel.getSubsUnreads(at: section)) { subsunread in
            LDRFeedRow(
              title: subsunread.title,
              unreadCount: subsunread.state != .read ? "\(subsunread.unreadCount)" : "",
              color: subsunread.state == .unread ? .blue : .gray
            )
            .onTap {
              guard let unread = feedViewModel.unreads[subsunread] else {
                return
              }
              feedViewModel.touchAll(subsunread: subsunread)
              feedViewModel.selectUnread(unread: unread)
            }
          }
        }
      }
    }
    .listStyle(PlainListStyle())
  }
    
  var navigationLink: some View {
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
    LDRFeedView(feedViewModel: LDRFeedViewModel()).environmentObject(LDRLoginViewModel())
  }
}
