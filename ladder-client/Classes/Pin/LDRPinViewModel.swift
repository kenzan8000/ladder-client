import Combine
import SwiftyJSON
import SwiftUI

// MARK: - LDRPinViewModel
final class LDRPinViewModel: ObservableObject {
    
  // MARK: property
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
  @Published var error: Error?
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
    
  init() {
    pins = LDRPin.fetch()
    NotificationCenter.default.publisher(for: LDRNotificationCenter.didLogin)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.pinAllCancellable?.cancel()
        self?.pinRemoveCancellables.forEach { $0.cancel() }
        self?.loadPinsFromAPI()
        self?.isPresentingLoginView = false
      }
      .store(in: &notificationCancellables)
    NotificationCenter.default.publisher(for: LDRNotificationCenter.didBecomeActive)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.loadPinsFromAPI()
      }
      .store(in: &notificationCancellables)
    NotificationCenter.default.publisher(for: LDRNotificationCenter.willCloseLoginView)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.isPresentingLoginView = false
      }
      .store(in: &notificationCancellables)
  }

  // MARK: public api
    
  /// Load Pins from local DB
  func loadPinsFromLocalDB() {
    pins = LDRPin.fetch()
  }
    
  /// Load Pins from API
  func loadPinsFromAPI() {
    pinAllCancellable?.cancel()
    _ = LDRPin.deleteAll()
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    pinAllCancellable = URLSession.shared.publisher(for: .pinAll(), using: decoder)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] result in
          if case let .failure(error) = result {
            self?.error = error
          } else {
            self?.pins = LDRPin.fetch()
          }
        },
        receiveValue: { [weak self] responses in
          if let error = LDRPin.save(responses: responses) {
            self?.error = error
          }
        }
     )
  }
    
  /// Delete Pin from local db and call delete API
  /// - Parameter pin: LDRPin model
  func delete(pin: LDRPin) {
    guard let url = pin.linkUrl else {
      error = LDRError.invalidLdrUrl
      return
    }
    safariUrl = url
    if let error = LDRPin.delete(pin: pin) {
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
    pins = LDRPin.fetch()
  }
  
}
