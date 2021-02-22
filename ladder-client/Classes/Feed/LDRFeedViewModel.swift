import Combine
import SwiftyJSON
import SwiftUI

// MARK: - LDRFeedViewModel
final class LDRFeedViewModel: ObservableObject {
    
  // MARK: property
  @Published var segment: LDRFeedSubsUnread.Segment
  @Published var subsunreads: [LDRFeedSubsUnread]
  @Published var rates: [String] = []
  @Published var folders: [String] = []
  var sections: [String] {
    segment == LDRFeedSubsUnread.Segment.rate ? rates : folders
  }
  @Published var unreads: [LDRFeedSubsUnread: LDRFeedUnread] = [:]
  @Published var unread: LDRFeedUnread?
  var isPresentingDetailView: Binding<Bool> {
    Binding<Bool>(
      get: { self.unread != nil },
      set: { newValue in
        guard !newValue else {
          return
        }
        self.unread = nil
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
    var count = 0
    for (subsunread, unread) in unreads {
      if unread.state == LDRFeedUnread.State.read {
        continue
      }
      count += subsunread.unreadCountValue
    }
    return count
  }
  private var notificationCancellables = Set<AnyCancellable>()

  // MARK: initialization
    
  init() {
    segment = LDRFeedSubsUnread.Segment.rate
    subsunreads = LDRFeedSubsUnread.fetch(segment: LDRFeedSubsUnread.Segment.rate)
    rates = LDRFeedSubsUnread.getRates(subsunreads: subsunreads)
    folders = LDRFeedSubsUnread.getFolders(subsunreads: subsunreads)
    NotificationCenter.default.publisher(for: LDRNotificationCenter.didLogin)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.loadFeedFromAPI()
        self?.isPresentingLoginView = false
      }
      .store(in: &notificationCancellables)
    NotificationCenter.default.publisher(for: LDRNotificationCenter.didBecomeActive)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.loadFeedFromAPI()
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
    
  /// Load Feed from local DB
  func loadFeedFromLocalDB() {
    subsunreads = LDRFeedSubsUnread.fetch(segment: segment)
    rates = LDRFeedSubsUnread.getRates(subsunreads: subsunreads)
    folders = LDRFeedSubsUnread.getFolders(subsunreads: subsunreads)
  }
    
  /// Load Feed from API
  func loadFeedFromAPI() {
    if isLoading {
      return
    }
    isLoading = true
    LDRFeedOperationQueue.shared.requestSubs { [weak self] (json: JSON?, error: Error?) -> Void in
      self?.isLoading = false
      if let error = error {
        self?.error = error
      } else if let error = LDRFeedSubsUnread.delete() {
        self?.error = error
      } else if let json = json, let error = LDRFeedSubsUnread.save(json: json) {
        self?.error = error
      } else {
        self?.loadFeedFromLocalDB()
        self?.loadUnreadsFromAPI()
      }
    }
  }
    
  /// Request feed is touched (read)
  /// - Parameter unread: this unread is already read
  func touchAll(unread: LDRFeedUnread) {
    if unread.state == LDRFeedUnread.State.unread {
      unread.requestTouchAll()
    }
  }
    
  /// Select LDRFeedUnread to focus
  /// - Parameter unread: LDRFeedUnread
  func selectUnread(unread: LDRFeedUnread) {
    self.unread = unread
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
    unreads = [:]
    for subsunread in subsunreads {
      let unread = LDRFeedUnread(subscribeId: subsunread.subscribeId, title: subsunread.title)
      unreads[subsunread] = unread
      isLoading = true
      unread.request { [weak self] unread in
        self?.unreads[subsunread] = unread
        self?.isLoading = unread.requestCount > 0
      }
    }
  }
}
