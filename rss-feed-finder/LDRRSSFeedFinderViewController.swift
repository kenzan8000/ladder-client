import UIKit
import UniformTypeIdentifiers

// MARK: - LDRRSSFeedFinderViewController
class LDRRSSFeedFinderViewController: UIViewController {
  // MARK: property
  private let keychain: LDRKeychain = LDRKeychainStore(service: LDR.service, group: LDR.group)
  private lazy var viewModel = LDRRSSFeedFinderViewModel(
    urlSession: LDRDefaultURLSession(keychain: keychain)
  )

  // MARK: life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let url = URL(string: "https://kenzan8000.org/") else {
      return
    }
    Task {
      do {
        let response = try await viewModel.loadRSSFeeds(from: url)
      } catch {
        print(error)
      }
    }
    /*
    let keychainStore = LDRKeychainStore(service: LDR.service, group: LDR.group)
    guard let items = extensionContext?.inputItems as? [NSExtensionItem],
          let apiKey = keychainStore.apiKey,
          let ldrUrlString = keychainStore.ldrUrlString else {
      return
    }
    items
      .compactMap { $0.attachments }
      .flatMap { $0 }
      .filter {
        $0.hasItemConformingToTypeIdentifier(UTType.url.identifier)
      }
    */
  }

}
