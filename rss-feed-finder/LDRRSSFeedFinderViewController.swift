import UIKit
import UniformTypeIdentifiers

// MARK: - LDRRSSFeedFinderViewController
class LDRRSSFeedFinderViewController: UIViewController {

  // MARK: life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
