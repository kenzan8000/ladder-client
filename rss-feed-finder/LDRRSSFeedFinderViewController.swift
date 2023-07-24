import UIKit

// MARK: - LDRRSSFeedFinderViewController
class LDRRSSFeedFinderViewController: UIViewController {
    // MARK: property
    private let viewModel = LDRRSSFeedFinderViewModel(
        keychain: LDRKeychainStore(service: LDR.service, group: LDR.group)
    )

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        Task {
            do {
                let feedResponse = try await viewModel.loadRSSFeeds(extensionContext: extensionContext)
            } catch {
                print(error)
            }
        }
        */
    }

}
