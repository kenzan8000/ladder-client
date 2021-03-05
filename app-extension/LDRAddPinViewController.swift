import Combine
import MobileCoreServices
import UIKit

// MARK: - LDRAddPinViewController
class LDRAddPinViewController: UIViewController {

  // MARK: property
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var label: UILabel!
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
      label.text = "Could not retrieve the URL to add to your 'read later' list."
      return
    }

    items
      .compactMap { $0.attachments }
      .flatMap { $0 }
      .filter { $0.hasItemConformingToTypeIdentifier(kUTTypeURL as String) }
      .publisher
      .flatMap { provider in
        Future<URL, Swift.Error> { promise in
          provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { data, error in
            if let url = data as? URL {
              promise(.success(url))
            } else {
              promise(.failure(LDRError.failed("Could not retrieve the URL to add to your 'read later' list.")))
            }
          }
        }
        .eraseToAnyPublisher()
      }
      .flatMap { (url: URL) -> AnyPublisher<LDRHTMLTitleResponse, Swift.Error> in
        URLSession.shared.publisher(for: .htmlTitle(url: url))
      }
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveOutput: { (response: LDRHTMLTitleResponse) in
        let storageProvider = LDRStorageProvider()
        if !storageProvider.existPin(link: response.url.absoluteString) {
          storageProvider.savePin(title: response.title, link: response.url.absoluteString)
        }
      })
      .flatMap { (response: LDRHTMLTitleResponse) -> AnyPublisher<LDRPinAddResponse, Swift.Error> in
        URLSession.shared.publisher(for: .pinAdd(title: response.title, link: response.url))
      }
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] result in
          self?.activityIndicatorView.isHidden = true
          if case .failure(_) = result {
            self?.label.text = "Failed to add the URL to your 'read later' list. You might have already added the same URL. Make sure your ladder-client app's settings are appropriate."
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
