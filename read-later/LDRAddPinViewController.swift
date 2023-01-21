import Combine
import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

// MARK: - LDRAddPinViewController
class LDRAddPinViewController: UIViewController {

  // MARK: property
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var label: UILabel!
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let keychainStore = LDRKeychainStore(service: LDR.service, group: LDR.group)
    guard let items = extensionContext?.inputItems as? [NSExtensionItem],
          let apiKey = keychainStore.apiKey,
          let ldrUrlString = keychainStore.ldrUrlString else {
      label.text = "Could not retrieve the URL to add to your 'read later' list."
      return
    }
    items
      .compactMap { $0.attachments }
      .flatMap { $0 }
      .filter { $0.hasItemConformingToTypeIdentifier(UTType.url.identifier) }
      .publisher
      .flatMap { provider in
        Future<URL, LDRError> { promise in
          provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { data, error in
            if let url = data as? URL {
              promise(.success(url))
            } else {
              promise(.failure(LDRError.others("Could not retrieve the URL to add to your 'read later' list.")))
            }
          }
        }
        .eraseToAnyPublisher()
      }
      .flatMap { (url: URL) -> AnyPublisher<LDRHTMLTitleResponse, LDRError> in
        URLSession.shared.publisher(for: .htmlTitle(url: url))
      }
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveOutput: { (response: LDRHTMLTitleResponse) in
        let storageProvider = LDRStorageProvider(name: LDR.coreData, group: LDR.group)
        if !storageProvider.existPin(link: response.url.absoluteString) {
          storageProvider.savePin(title: response.title, link: response.url.absoluteString)
        }
      })
      .flatMap { (response: LDRHTMLTitleResponse) -> AnyPublisher<LDRPinAddResponse, LDRError> in
        URLSession.shared.publisher(for: .pinAdd(apiKey: apiKey, ldrUrlString: ldrUrlString, title: response.title, link: response.url))
      }
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] result in
          self?.activityIndicatorView.isHidden = true
          if case let .failure(error) = result {
            self?.label.text = error.legibleDescription
          }
          else {
            self?.label.text = "Succeeded to add the URL to your 'read later' list."
            self?.extensionContext?.completeRequest(returningItems: self?.extensionContext?.inputItems, completionHandler: nil)
          }
        },
        receiveValue: { _ in }
      )
      .store(in: &cancellables)
  }

}
