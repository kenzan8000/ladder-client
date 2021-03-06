import SwiftUI

// MARK: - LDRFeedView
struct LDRFeedView: View {
  // MARK: property

  let keychain: LDRKeychain
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
        LDRLoginView(keychain: keychain)
      }
    }
    .alert(isPresented: feedViewModel.isPresentingAlert) {
      Alert(title: Text(feedViewModel.error?.legibleDescription ?? ""))
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
        .tag(LDRFeedSubsUnreadSegment.rate)
      Image(systemName: "folder.fill")
        .foregroundColor(feedViewModel.segment == .folder ? .blue : .gray)
        .tag(LDRFeedSubsUnreadSegment.folder)
    }
      .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
      .pickerStyle(SegmentedPickerStyle())
      .animation(nil)
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
              feedViewModel.touchAll(subsunread: subsunread)
            }
          }
        }
      }
    }
    .listStyle(PlainListStyle())
  }
    
  var navigationLink: some View {
    if let subsunread = feedViewModel.subsunread,
       subsunread.state != .unloaded {
      let feedDetailView = LDRFeedDetailView(
        feedDetailViewModel: LDRFeedDetailViewModel(storageProvider: feedViewModel.storageProvider, keychain: keychain, subsunread: subsunread),
        feedDetailWebViewModel: LDRFeedDetailWebViewModel()
      )
      return AnyView(
        NavigationLink(
          "",
          destination: feedDetailView,
          isActive: feedViewModel.isPresentingDetailView
        )
      )
    }
    return AnyView(EmptyView())
  }
}

// MARK: - LDRFeedView_Previews
struct LDRFeedView_Previews: PreviewProvider {
  static var previews: some View {
    let keychain = LDRKeychainStore(service: LDR.service, group: LDR.group)
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      LDRFeedView(keychain: keychain, feedViewModel: LDRFeedViewModel(storageProvider: LDRStorageProvider(name: LDR.coreData, group: LDR.group), keychain: keychain, segment: .rate))
        .environmentObject(LDRLoginViewModel(keychain: keychain))
        .colorScheme($0)
    }
  }
}
