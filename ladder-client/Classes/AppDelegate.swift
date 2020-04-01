import Firebase
import UIKit


/// MARK: - AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// MARK: - property
    var window: UIWindow?


    /// MARK: - delegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // firebase
        FirebaseApp.configure()

        // remember last session
        let url = LDRUrl(path: LDR.login)
        if url != nil && url!.host != nil {
            let session = UserDefaults(suiteName: LDRUserDefaults.suiteName)?.string(forKey: LDRUserDefaults.session)
            if session != nil {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": "\(LDR.cookieName)=\(session!)"], for: url!)
                for cookie in cookies { HTTPCookieStorage.shared.setCookie(cookie) }
            }
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

