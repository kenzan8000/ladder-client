import SwiftUI

// MARK: - LDRPinView
struct LDRPinView: View {
  // MARK: property

  let keychain: LDRKeychain
  @ObservedObject var pinViewModel: ViewModel
  @EnvironmentObject var loginViewModel: LDRLoginView.ViewModel
    
  var body: some View {
    NavigationView {
      list
    }
      .onAppear {
        pinViewModel.loadPinsFromLocalDB()
      }
      .sheet(isPresented: pinViewModel.isPresentingSafariView) {
        safariView
      }
      .alert(isPresented: pinViewModel.isPresentingAlert) {
        Alert(title: Text(pinViewModel.error?.legibleDescription ?? ""))
      }
  }
  
  var list: some View {
    List(pinViewModel.pins) { pin in
      LDRPinRow(viewModel: .init(pin: pin))
        .onTap { pinViewModel.delete(pin: pin) }
    }
    .listStyle(PlainListStyle())
    .navigationBarTitle("\(pinViewModel.pins.count) Pins", displayMode: .large)
    .navigationBarItems(
      leading: loginButton,
      trailing: reloadButton
    )
    .sheet(isPresented: $pinViewModel.isPresentingLoginView) {
      LDRLoginView(keychain: keychain)
    }

  }
 
  var loginButton: some View {
    Button(
      action: {
        pinViewModel.isPresentingLoginView.toggle()
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
        pinViewModel.loadPinsFromAPI()
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
    guard let url = pinViewModel.safariUrl else {
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
      LDRPinView(keychain: keychain, pinViewModel: LDRPinView.ViewModel(storageProvider: LDRStorageProvider(name: LDR.coreData, group: LDR.group), keychain: LDRKeychainStore(service: LDR.service, group: LDR.group)))
        .environmentObject(LDRLoginView.ViewModel(keychain: keychain))
        .colorScheme($0)
    }
  }
}
