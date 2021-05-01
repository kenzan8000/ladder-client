import SwiftUI

// MARK: - LDRTabView
struct LDRTabView: View {
  // MARK: enum
    
  enum Tab: Int {
    case feed = 0
    case pin = 1
  }
    
  // MARK: property
  
  let keychain: LDRKeychain
  @State var selected: Tab
  var feedViewModel: LDRFeedViewModel
  var pinViewModel: LDRPinViewModel
  @EnvironmentObject var loginViewModel: LDRLoginViewModel
    
  var body: some View {
    TabView(selection: $selected) {
      feedView
      pinView
    }
  }

  var feedView: some View {
    LDRFeedView(keychain: keychain, feedViewModel: feedViewModel)
    .tabItem {
      Image(systemName: "wifi")
      Text("RSS Feeds")
    }
    .tag(Tab.feed)
  }
        
  var pinView: some View {
    LDRPinView(keychain: keychain, pinViewModel: pinViewModel)
    .tabItem {
      Image(systemName: "pin.fill")
      Text("Read Later Pins")
    }
    .tag(Tab.pin)
  }
}

// MARK: - LDRTabViewPin_Previews
struct LDRTabView_Previews: PreviewProvider {
  static var previews: some View {
    let storageProvider = LDRStorageProvider(name: LDR.coreData, group: LDR.group)
    let keychain = LDRKeychainStore(service: LDR.service, group: LDR.group)
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) { colorScheme in
      LDRTabView(
        keychain: keychain,
        selected: LDRTabView.Tab.feed,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider, keychain: keychain)
      )
      .environmentObject(LDRLoginViewModel(keychain: keychain))
      .preferredColorScheme(colorScheme)
      
      LDRTabView(
        keychain: keychain,
        selected: LDRTabView.Tab.pin,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider, keychain: keychain)
      )
      .environmentObject(LDRLoginViewModel(keychain: keychain))
      .preferredColorScheme(colorScheme)
    }
  }
}
