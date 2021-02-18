import FirebaseCore
import KeychainAccess
import SwiftUI
import UIKit

// MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - property

    var window: UIWindow?

    // MARK: - life cycle

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        FirebaseApp.configure()

        // remember last session
        if let url = LDRRequestHelper.createUrl(path: LDR.login) {
            if url.host != nil {
                if let session = Keychain(
                    service: LDRKeychain.serviceName,
                    accessGroup: LDRKeychain.suiteName
                    )[LDRKeychain.session] {

                    let cookies = HTTPCookie.cookies(
                        withResponseHeaderFields: ["Set-Cookie": "\(LDR.cookieName)=\(session)"],
                        for: url
                    )
                    for cookie in cookies {
                        HTTPCookieStorage.shared.setCookie(cookie)
                    }
                }
            }
        }
        
        let tabView = LDRTabView(
          loginViewModel: LDRLoginViewModel(),
          feedViewModel: LDRFeedViewModel(),
          pinViewModel: LDRPinViewModel()
        )

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: tabView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationCenter.default.post(name: LDRNotificationCenter.didBecomeActive, object: nil)
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}
