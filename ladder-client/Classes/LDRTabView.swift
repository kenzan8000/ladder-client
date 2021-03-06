import SwiftUI

// MARK: - LDRTabView
struct LDRTabView: View {
  // MARK: enum
    
  enum Tab: Int {
    case feed = 0
    case pin = 1
  }
    
  // MARK: property
    
  @State private var selected = Tab.feed
  @EnvironmentObject var loginViewModel: LDRLoginViewModel
  var feedViewModel: LDRFeedViewModel
  var pinViewModel: LDRPinViewModel
    
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

// MARK: - LDRTabView_Previews
struct LDRTabView_Previews: PreviewProvider {
  static var previews: some View {
    let storageProvider = LDRStorageProvider(name: .ldrCoreData, group: .ldrGroup)
    return LDRTabView(
      feedViewModel: LDRFeedViewModel(storageProvider: storageProvider),
      pinViewModel: LDRPinViewModel(storageProvider: storageProvider)
    )
    .environmentObject(LDRLoginViewModel())
  }
}
