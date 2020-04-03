import Firebase
import UIKit


/// MARK: - AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// MARK: - property
    var window: UIWindow?


    /// MARK: - delegate
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // init firebase
        FirebaseApp.configure()

        // remember last session
        guard let url = LDRUrl(path: LDR.login) else { return true }
        if url.host == nil { return true }
        let session = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.session)
        if session == nil { return true }
        let cookies = HTTPCookie.cookies(
            withResponseHeaderFields: ["Set-Cookie": "\(LDR.cookieName)=\(session!)"],
            for: url
        )
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

