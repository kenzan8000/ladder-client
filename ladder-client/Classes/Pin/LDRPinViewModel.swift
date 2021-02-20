import Combine
import SwiftyJSON
import SwiftUI

// MARK: - LDRPinViewModel
final class LDRPinViewModel: ObservableObject {
    
  // MARK: - model
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
  private var cancellables = Set<AnyCancellable>()
    
  // MARK: - initialization
    
  init() {
    pins = LDRPin.fetch()
    NotificationCenter.default.publisher(for: LDRNotificationCenter.didLogin)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.loadPinsFromAPI()
        self?.isPresentingLoginView = false
      }
      .store(in: &cancellables)
    NotificationCenter.default.publisher(for: LDRNotificationCenter.didBecomeActive)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.loadPinsFromAPI()
      }
      .store(in: &cancellables)
    NotificationCenter.default.publisher(for: LDRNotificationCenter.willCloseLoginView)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.isPresentingLoginView = false
      }
      .store(in: &cancellables)
  }

  // MARK: - public api
    
  /// Load Pins from local DB
  func loadPinsFromLocalDB() {
      pins = LDRPin.fetch()
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
    if let url = pin.linkUrl {
      safariUrl = url
      LDRPinOperationQueue.shared.requestPinRemove(link: url) { _, _ in }
    }
    if let error = LDRPin.delete(pin: pin) {
      self.error = error
      return
    }
    pins = LDRPin.fetch()
  }
  
}
