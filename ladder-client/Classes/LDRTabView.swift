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
    var feedViewModel: LDRFeedView.ViewModel
    var pinViewModel: LDRPinView.ViewModel
    @EnvironmentObject var loginViewModel: LDRLoginView.ViewModel
        
    var body: some View {
        TabView(selection: $selected) {
            feedView
            pinView
        }
    }

    var feedView: some View {
        LDRFeedView(keychain: keychain, viewModel: feedViewModel)
        .tabItem {
            Image(systemName: "wifi")
            Text("RSS Feeds")
        }
        .tag(Tab.feed)
    }
                
    var pinView: some View {
        LDRPinView(keychain: keychain, viewModel: pinViewModel)
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
                feedViewModel: LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate),
                pinViewModel: LDRPinView.ViewModel(storageProvider: storageProvider, keychain: keychain)
            )
            .environmentObject(LDRLoginView.ViewModel(keychain: keychain))
            .preferredColorScheme(colorScheme)
            
            LDRTabView(
                keychain: keychain,
                selected: LDRTabView.Tab.pin,
                feedViewModel: LDRFeedView.ViewModel(storageProvider: storageProvider, keychain: keychain, segment: .rate),
                pinViewModel: LDRPinView.ViewModel(storageProvider: storageProvider, keychain: keychain)
            )
            .environmentObject(LDRLoginView.ViewModel(keychain: keychain))
            .preferredColorScheme(colorScheme)
        }
    }
}
