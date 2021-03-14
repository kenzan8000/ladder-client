import SwiftUI

// MARK: - LDRTabView
struct LDRTabView: View {
  // MARK: enum
    
  enum Tab: Int {
    case feed = 0
    case pin = 1
  }
    
  // MARK: property
    
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
    LDRFeedView(feedViewModel: feedViewModel)
    .tabItem {
      Image(systemName: "wifi")
      Text("RSS Feeds")
    }
    .tag(Tab.feed)
  }
        
  var pinView: some View {
    LDRPinView(pinViewModel: pinViewModel)
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
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) { colorScheme in
      LDRTabView(
        selected: LDRTabView.Tab.feed,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, segment: .rate),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider)
      )
      .environmentObject(LDRLoginViewModel())
      .preferredColorScheme(colorScheme)
      
      LDRTabView(
        selected: LDRTabView.Tab.pin,
        feedViewModel: LDRFeedViewModel(storageProvider: storageProvider, segment: .rate),
        pinViewModel: LDRPinViewModel(storageProvider: storageProvider)
      )
      .environmentObject(LDRLoginViewModel())
      .preferredColorScheme(colorScheme)
    }
  }
}
