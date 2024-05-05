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
    private let keychain = Keychain(service: "org.kenzan8000.ladder-client", accessGroup: "group.ladder-client")

    var body: some Scene {
        WindowGroup {
            RootTabView(selectedTab: .feeds)
                .environmentObject(RootTabViewModel(
                    keychain: keychain,
                    signInService: SignInService(
                        keychain: keychain,
                        networking: SignInNetworking(keychain: keychain),
                        cookieStorage: CookieStorage()
                    )
                ))
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
