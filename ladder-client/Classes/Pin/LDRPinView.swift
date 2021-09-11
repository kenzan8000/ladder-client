import SwiftUI

// MARK: - LDRPinView
struct LDRPinView: View {
  // MARK: property

  let keychain: LDRKeychain
  @ObservedObject var viewModel: ViewModel
  @EnvironmentObject var loginViewModel: LDRLoginView.ViewModel
    
  var body: some View {
    NavigationView {
      list
    }
      .onAppear {
        viewModel.loadPinsFromLocalDB()
      }
      .sheet(isPresented: viewModel.isPresentingSafariView) {
        safariView
      }
      .alert(item: $viewModel.alertToShow) {
        Alert(
          title: Text($0.title),
          message: Text($0.message),
          dismissButton: .default(Text($0.buttonText))
        )
      }
  }
  
  var list: some View {
    List(viewModel.pins) { pin in
      LDRPinRow(viewModel: .init(pin: pin))
        .onTap { viewModel.delete(pin: pin) }
    }
    .listStyle(PlainListStyle())
    .navigationBarTitle("\(viewModel.pins.count) Pins", displayMode: .large)
    .navigationBarItems(
      leading: loginButton,
      trailing: reloadButton
    )
    .sheet(isPresented: $viewModel.isPresentingLoginView) {
      LDRLoginView(keychain: keychain)
    }
    .refreshable { viewModel.loadPinsFromAPI() }
  }
 
  var loginButton: some View {
    Button(
      action: {
        viewModel.isPresentingLoginView.toggle()
      },
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
        viewModel.loadPinsFromAPI()
      },
      label: {
        Text("Reload")
          .foregroundColor(.blue)
        Image(systemName: "arrow.clockwise")
          .foregroundColor(.blue)
      }
    )
  }
    
  var safariView: some View {
    guard let url = viewModel.safariUrl else {
      return AnyView(EmptyView())
    }
    return AnyView(SafariView(url: url))
  }
}

// MARK: - LDRPinView_Previews
struct LDRPinView_Previews: PreviewProvider {
  static var previews: some View {
    let keychain = LDRKeychainStore(service: LDR.service, group: LDR.group)
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      LDRPinView(keychain: keychain, viewModel: .init(storageProvider: LDRStorageProvider(name: LDR.coreData, group: LDR.group), keychain: LDRKeychainStore(service: LDR.service, group: LDR.group)))
        .environmentObject(LDRLoginView.ViewModel(keychain: keychain))
        .colorScheme($0)
    }
  }
}
