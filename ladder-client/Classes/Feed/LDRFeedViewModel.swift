import Combine
import SwiftUI

// MARK: - LDRFeedViewModel
final class LDRFeedViewModel: ObservableObject {
    
  // MARK: property
  @Published var segment: LDRFeedSubsUnread.Segment
  @Published var rates: [String] = []
  @Published var folders: [String] = []
  var sections: [String] {
    segment == LDRFeedSubsUnread.Segment.rate ? rates : folders
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
    
  init() {
    segment = LDRFeedSubsUnread.Segment.rate
    subsunreads = LDRFeedSubsUnread.fetch(segment: LDRFeedSubsUnread.Segment.rate)
    rates = LDRFeedSubsUnread.getRates(subsunreads: subsunreads)
    folders = LDRFeedSubsUnread.getFolders(subsunreads: subsunreads)
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
    subsunreads = LDRFeedSubsUnread.fetch(segment: segment)
    rates = LDRFeedSubsUnread.getRates(subsunreads: subsunreads)
    folders = LDRFeedSubsUnread.getFolders(subsunreads: subsunreads)
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
          if let error = LDRFeedSubsUnread.delete() {
            self?.error = error
          } else if let error = LDRFeedSubsUnread.save(response: response) {
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
    subsunread.update(state: .read)
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
    if segment == LDRFeedSubsUnread.Segment.rate {
      return LDRFeedSubsUnread.filter(subsunreads: subsunreads, rate: section)
    }
    return LDRFeedSubsUnread.filter(subsunreads: subsunreads, folder: section)
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
            LDRFeedUnread.save(subsunread: subsunread, response: response)
            subsunread.update(state: .unread)
            self?.loadFeedFromLocalDB()
          }
        }
      )
      .store(in: &unreadCancellables)
  }
}
