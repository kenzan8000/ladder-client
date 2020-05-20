import Firebase
import KeychainAccess
import UIKit

// MARK: - AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - property
    var window: UIWindow?

    // MARK: - life cycle
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // init firebase
        FirebaseApp.configure()

        // remember last session
        guard let url = LDRRequestHelper.createUrl(path: LDR.login) else {
            return true
        }
        if url.host == nil {
            return true
        }
        guard let session = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
            )[LDRKeychain.session] else {
            return true
        }
        let cookies = HTTPCookie.cookies(
            withResponseHeaderFields: ["Set-Cookie": "\(LDR.cookieName)=\(session)"],
            for: url
        )
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: LDRNotificationCenter.willResignActive, object: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: LDRNotificationCenter.didBecomeActive, object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
