import Combine
import SwiftyJSON
import SwiftUI

// MARK: - LDRPinViewModel
final class LDRPinViewModel: ObservableObject {
    
  // MARK: - model
  @Published var pins: [LDRPin]
  @Published var isLoading = false
  @Published var safariUrl: URL?
  var isPresentingSafariView: Binding<Bool> {
    Binding<Bool>(
      get: { self.safariUrl != nil },
      set: { newValue in
        guard !newValue else {
          return
        }
        self.safariUrl = nil
      }
    )
  }
  @Published var isPresentingLoginView = false
  @Published var error: Error?
  var isPresentingAlert: Binding<Bool> {
    Binding<Bool>(
      get: { self.error != nil },
      set: { newValue in
        guard !newValue else {
          return
        }
        self.error = nil
      }
    )
  }
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

  // MARK: - destruction

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - public api
    
  /// Load Pins from local DB
  func loadPinsFromLocalDB() {
      pins = LDRPin.fetch()
  }
    
  /// Load Pins from API
  func loadPinsFromAPI() {
    if isLoading {
      return
    }
    isLoading = true
    LDRPinOperationQueue.shared.requestPinAll { [unowned self] (json: JSON?, error: Error?) -> Void in
      if let error = error {
        self.error = error
      } else if let error = LDRPin.deleteAll() {
        self.error = error
      } else if let json = json, let error = LDRPin.save(json: json) {
        self.error = error
      } else {
        self.pins = LDRPin.fetch()
      }
      self.isLoading = false
    }
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
