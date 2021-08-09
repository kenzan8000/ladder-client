import Combine
import SwiftUI

// MARK: - LDRPinView + ViewModel
extension LDRPinView {
  // MARK: ViewModel
  class ViewModel: ObservableObject {
      
    // MARK: property
    let storageProvider: LDRStorageProvider
    let keychain: LDRKeychain
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
      
    // MARK: initializer
    
    /// Inits
    /// - Parameters:
    ///   - storageProvider: coredata
    ///   - keychain: LDRKeychain
    init(storageProvider: LDRStorageProvider, keychain: LDRKeychain) {
      self.storageProvider = storageProvider
      self.keychain = keychain
      pins = storageProvider.fetchPins()
      NotificationCenter.default.publisher(for: .ldrDidLogin)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
          self?.reloadPins()
          self?.isPresentingLoginView = false
        }
        .store(in: &notificationCancellables)
      NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
          self?.loadPinsFromLocalDB()
          if let self = self,
             self.keychain.reloadTimestampIsExpired {
            self.reloadPins()
          }
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
      pinAllCancellable = URLSession.shared.publisher(for: .pinAll(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString), using: decoder)
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
      URLSession.shared.publisher(for: .pinRemove(apiKey: keychain.apiKey, ldrUrlString: keychain.ldrUrlString, link: url))
        .receive(on: DispatchQueue.main)
        .sink(
          receiveCompletion: { [weak self] result in
            if case let .failure(error) = result {
              self?.error = error
            }
          },
          receiveValue: { [weak self] response in
            if !response.isSuccess {
              self?.error = LDRError.others("Failed to remove a pin. (\(url.absoluteString))")
            }
          }
        )
        .store(in: &pinRemoveCancellables)
      pins = storageProvider.fetchPins()
    }
    
    // MARK: private api
    
    /// Stops current loadings and reloads pins
    private func reloadPins() {
      pinAllCancellable?.cancel()
      pinRemoveCancellables.forEach { $0.cancel() }
      loadPinsFromAPI()
    }
  }
}
