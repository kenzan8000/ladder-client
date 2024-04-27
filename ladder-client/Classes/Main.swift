import KeychainAccess
import SwiftUI

// MARK: - Main

// swiftlint:disable convenience_type
@main
struct Main {
    static func main() throws {
        guard NSClassFromString("XCTestCase") == nil else {
            TestApp.main()
            return
        }
        LadderClientApp.main()
    }
}
// swiftlint:enable convenience_type

// MARK: - LadderClientApp

struct LadderClientApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView(selectedTab: .feeds)
                .environmentObject(RootTabViewModel(keychain: Keychain(service: "org.kenzan8000.ladder-client", accessGroup: "group.ladder-client")))
        }
    }
}

// MARK: - TestApp
struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Running Tests")
        }
    }
}
