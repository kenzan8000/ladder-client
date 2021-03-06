import Combine
import SwiftUI

// MARK: - LDRFeedViewModel
final class LDRFeedViewModel: ObservableObject {
    
  // MARK: property
  var storageProvider: LDRStorageProvider
  @Published var segment: LDRFeedSubsUnreadSegment
  @Published var rates: [String] = []
  @Published var folders: [String] = []
  var sections: [String] {
    segment == .rate ? rates : folders
  }
  @Published var subsunreads: [LDRFeedSubsUnread]
  @Published var subsunread: LDRFeedSubsUnread?
  var isPresentingDetailView: Binding<Bool> {
    Binding<Bool>(
      get: { self.subsunread != nil },
      set: { newValue in
        guard !newValue else {
          return
        }
        self.subsunread = nil
      }
    )
  }
  @Published var isPresentingLoginView = false
  @Published var isLoading = false
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
  var unreadCount: Int {
    subsunreads.filter { $0.state != .read }
      .map { $0.unreadCount }
      .reduce(0, +)
  }
  
  private var notificationCancellables = Set<AnyCancellable>()
  private var subsCancellable: AnyCancellable?
  private var touchAllCancellables = Set<AnyCancellable>()
  private var unreadCancellables = Set<AnyCancellable>()
  private var unreadOperationQueue = LDRFeedUnreadOperationQueue()

  // MARK: initialization
  
  /// Inits
  /// - Parameter storageProvider: for CoreData
  init(storageProvider: LDRStorageProvider) {
    self.storageProvider = storageProvider
    segment = .rate
    subsunreads = storageProvider.fetchSubsUnreads(by: .rate)
    rates = Array(Set(subsunreads.map { $0.rateString })).sorted()
    folders = Array(Set(subsunreads.map { $0.folder })).sorted()
    NotificationCenter.default.publisher(for: .ldrDidLogin)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.loadFeedFromAPI()
        self?.isPresentingLoginView = false
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
    
  /// Load Feed from local DB
  func loadFeedFromLocalDB() {
    subsunreads = storageProvider.fetchSubsUnreads(by: segment)
    rates = Array(Set(subsunreads.map { $0.rateString })).sorted()
    folders = Array(Set(subsunreads.map { $0.folder })).sorted()
  }
    
  /// Load Feed from API
  func loadFeedFromAPI() {
    isLoading = true
    unreadCancellables.forEach { $0.cancel() }
    touchAllCancellables.forEach { $0.cancel() }
    subsCancellable?.cancel()
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    subsCancellable = URLSession.shared.publisher(for: .subs(), using: decoder)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] result in
          self?.isLoading = false
          if case let .failure(error) = result {
            self?.error = error
          } else {
            self?.loadFeedFromLocalDB()
            self?.loadUnreadsFromAPI()
          }
        },
        receiveValue: { [weak self] response in
          if let error = self?.storageProvider.deleteSubsUnreads() {
            self?.error = error
          } else if let error = self?.storageProvider.saveSubsUnreads(by: response) {
            self?.error = error
          }
        }
      )
  }
    
  /// Request feed is touched (read)
  /// - Parameter unread: this unread is already read
  func touchAll(subsunread: LDRFeedSubsUnread) {
    if subsunread.state != .unloaded {
      self.subsunread = subsunread
    }
    if subsunread.state == .read {
      return
    }
    storageProvider.updateSubsUnread(subsunread, state: .read)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    URLSession.shared.publisher(for: .touchAll(subscribeId: subsunread.subscribeId), using: decoder)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { _ in }
      )
      .store(in: &touchAllCancellables)
  }

  /// Get subsuread models at section
  /// - Parameter section: one of rates or folders
  /// - Returns:subsuread models belonging to the section
  func getSubsUnreads(at section: String) -> [LDRFeedSubsUnread] {
    switch segment {
    case .rate:
      return subsunreads.filter { $0.rateString == section }.sorted { $0.title < $1.title }
    case .folder:
      return subsunreads.filter { $0.folder == section }.sorted { $0.title < $1.title }
    }
  }
    
  // MARK: private api
    
  /// Load Unreads from API
  private func loadUnreadsFromAPI() {
    isLoading = !subsunreads.isEmpty
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    subsunreads.publisher
      .compactMap { $0.state == .unloaded ? $0 : nil }
      .flatMap { [weak self] subsunread in
        URLSession(configuration: .default, delegate: nil, delegateQueue: self?.unreadOperationQueue)
          .publisher(for: .unread(subscribeId: subsunread.subscribeId), using: decoder)
      }
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] _ in
          self?.isLoading = !(self?.unreadOperationQueue.operations.isEmpty ?? true)
        },
        receiveValue: { [weak self] response in
          if let subsunread = self?.subsunreads.first(where: { $0.subscribeId == response.subscribeId }) {
            self?.storageProvider.saveUnread(by: response, subsUnread: subsunread)
            self?.storageProvider.updateSubsUnread(subsunread, state: .unread)
            self?.loadFeedFromLocalDB()
          }
        }
      )
      .store(in: &unreadCancellables)
  }
}
