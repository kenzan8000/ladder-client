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
    // MARK: - Private properties
    
    private let keychain = Keychain(service: "org.kenzan8000.ladder-client", accessGroup: "group.ladder-client")
    
    private let cookieStorage = CookieStorage()
    
    // MARK: - Public properties

    var body: some Scene {
        WindowGroup {
            RootTabView(viewModel: RootTabViewModel(
                keychain: keychain,
                signInService: SignInService(
                    keychain: keychain,
                    networking: SignInNetworking(keychain: keychain),
                    cookieStorage: cookieStorage
                ),
                feedService: FeedService(),
                pinService: PinService(
                    keychain: keychain,
                    networking: PinNetworking(keychain: keychain),
                    cookieStorage: cookieStorage
                ),
                selectedTab: .feeds
            ))
        }
    }
}

// MARK: - TestApp
struct TestApp: App {
    // MARK: - Public properties
    
    var body: some Scene {
        WindowGroup {
            Text("Running Tests")
        }
    }
}
