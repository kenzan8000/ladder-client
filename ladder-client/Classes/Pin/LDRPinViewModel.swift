import Combine
import SwiftUI

// MARK: - LDRPinViewModel
final class LDRPinViewModel: ObservableObject {
    
  // MARK: property
  var storageProvider: LDRStorageProvider
  @Published var pins: [LDRPin]
  @Published var safariUrl: URL?
  var isPresentingSafariView: Binding<Bool> {
    Binding<Bool>(
      get: { [weak self] in self?.safariUrl != nil },
      set: { [weak self] newValue in
        guard !newValue else {
          return
        }
        self?.safariUrl = nil
      }
    )
  }
  @Published var isPresentingLoginView = false
  @Published var error: LDRError?
  var isPresentingAlert: Binding<Bool> {
    Binding<Bool>(
      get: { [weak self] in self?.error != nil },
      set: { [weak self] newValue in
        guard !newValue else {
          return
        }
        self?.error = nil
      }
    )
  }
  
  private var pinAllCancellable: AnyCancellable?
  private var pinRemoveCancellables = Set<AnyCancellable>()
  private var notificationCancellables = Set<AnyCancellable>()
    
  // MARK: initialization
  
  /// Inits
  /// - Parameter storageProvider: for CoreData
  init(storageProvider: LDRStorageProvider) {
    self.storageProvider = storageProvider
    pins = storageProvider.fetchPins()
    NotificationCenter.default.publisher(for: .ldrDidLogin)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.pinAllCancellable?.cancel()
        self?.pinRemoveCancellables.forEach { $0.cancel() }
        self?.loadPinsFromAPI()
        self?.isPresentingLoginView = false
      }
      .store(in: &notificationCancellables)
    NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.loadPinsFromLocalDB()
      }
      .store(in: &notificationCancellables)
    NotificationCenter.default.publisher(for: .ldrWillCloseLoginView)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.isPresentingLoginView = false
      }
      .store(in: &notificationCancellables)
  }

  // MARK: public api
    
  /// Load Pins from local DB
  func loadPinsFromLocalDB() {
    pins = storageProvider.fetchPins()
  }
    
  /// Load Pins from API
  func loadPinsFromAPI() {
    pinAllCancellable?.cancel()

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    pinAllCancellable = URLSession.shared.publisher(for: .pinAll(), using: decoder)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] result in
          if case let .failure(error) = result {
            self?.error = error
          } else {
            self?.pins = self?.storageProvider.fetchPins() ?? []
          }
        },
        receiveValue: { [weak self] responses in
          if let error = self?.storageProvider.deletePins() {
            self?.error = error
          } else if let error = self?.storageProvider.savePins(by: responses) {
            self?.error = error
          }
        }
     )
  }
    
  /// Delete Pin from local db and call delete API
  /// - Parameter pin: LDRPin model
  func delete(pin: LDRPin) {
    guard let url = pin.linkUrl else {
      return
    }
    safariUrl = url
    if let error = storageProvider.deletePin(pin) {
      self.error = error
      return
    }
    URLSession.shared.publisher(for: .pinRemove(link: url))
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] result in
          if case let .failure(error) = result {
            self?.error = error
          }
        },
        receiveValue: { [weak self] response in
          if !response.isSuccess {
            self?.error = LDRError.failed("Failed to remove a pin. (\(url.absoluteString))")
          }
        }
      )
      .store(in: &pinRemoveCancellables)
    pins = storageProvider.fetchPins()
  }
  
}
