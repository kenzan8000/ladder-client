import SwiftUI

// MARK: - LDRFeedView
struct LDRFeedView: View {
    // MARK: property

    let keychain: LDRKeychain
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var loginViewModel: LDRLoginView.ViewModel

    // MARK: property

    var body: some View {
        NavigationView {
            VStack {
                list
                navigationLink
            }
            .navigationBarTitle("\(viewModel.unreadCount) Updates")
            .navigationBarItems(leading: loginButton, trailing: reloadButton)
            .sheet(isPresented: $viewModel.isPresentingLoginView) {
                LDRLoginView(keychain: keychain)
            }
        }
        .navigationViewStyle(.stack)
        .alert(item: $viewModel.alertToShow) {
            Alert(
                title: Text($0.title),
                message: Text($0.message),
                dismissButton: .default(Text($0.buttonText))
            )
        }
        .onAppear {
            viewModel.loadFeedFromLocalDB()
        }
    }
        
    var loginButton: some View {
        Button(
            action: { viewModel.isPresentingLoginView.toggle() },
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
                viewModel.loadFeedFromAPI()
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
            selection: $viewModel.segment,
            label: EmptyView()
        ) {
            Image(systemName: "star.fill")
                .foregroundColor(viewModel.segment == .rate ? .blue : .gray)
                .tag(LDRFeedSubsUnreadSegment.rate)
            Image(systemName: "folder.fill")
                .foregroundColor(viewModel.segment == .folder ? .blue : .gray)
                .tag(LDRFeedSubsUnreadSegment.folder)
        }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .pickerStyle(SegmentedPickerStyle())
    }
        
    var list: some View {
        List {
            picker
            ForEach(viewModel.sections, id: \.self) { section in
                Section(header: Text(section)) {
                    ForEach(viewModel.getSubsUnreads(at: section)) { subsunread in
                        LDRFeedRow(viewModel: .init(subsunread: subsunread))
                            .onTap {
                                viewModel.touchAll(subsunread: subsunread)
                            }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable { viewModel.loadFeedFromAPI() }
    }
        
    var navigationLink: some View {
        if let subsunread = viewModel.subsunread,
             subsunread.state != .unloaded {
            let feedDetailView = LDRFeedDetailView(
                viewModel: LDRFeedDetailView.ViewModel(storageProvider: viewModel.storageProvider, keychain: keychain, subsunread: subsunread),
                webViewModel: LDRFeedDetailView.WebViewModel()
            )
            return AnyView(
                NavigationLink(
                    "",
                    destination: feedDetailView,
                    isActive: viewModel.isPresentingDetailView
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
            LDRFeedView(keychain: keychain, viewModel: LDRFeedView.ViewModel(storageProvider: LDRStorageProvider(name: LDR.coreData, group: LDR.group), keychain: keychain, segment: .rate))
                .environmentObject(LDRLoginView.ViewModel(keychain: keychain))
                .colorScheme($0)
        }
    }
}
