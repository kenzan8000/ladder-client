import Combine
import SwiftUI
import WebKit

// MARK: - LDRFeedDetailViewModel
final class LDRFeedDetailViewModel: ObservableObject {
    
  // MARK: property
  @Published var subsunread: LDRFeedSubsUnread
  @Published var index = 0
  let unreads: [LDRFeedUnread]
  var unread: LDRFeedUnread? { unreads[index] }
  var count: Int { unreads.count }
  var title: String { unread?.title ?? "" }
  var body: String { unread?.body ?? "" }
  var link: URL { unread?.linkUrl ?? URL(fileURLWithPath: "") }
  var prevTitle: String { index > 0 ? unreads[index - 1].title : "" }
  var nextTitle: String { index + 1 < unreads.count ? unreads[index + 1].title : "" }
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
  private var pinAddCancellables = Set<AnyCancellable>()
  private var notificationCancellables = Set<AnyCancellable>()

  // MARK: initialization
    
  init(subsunread: LDRFeedSubsUnread) {
    self.subsunread = subsunread
    unreads = subsunread.unreads.sorted { $0.id < $1.id }
    NotificationCenter.default.publisher(for: .ldrDidLogin)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.pinAddCancellables.forEach { $0.cancel() }
      }
      .store(in: &notificationCancellables)
  }

  // MARK: public api
    
  /// Update unread index to next or previous unread
  /// - Parameter offset: offset to move 1 or -1
  /// - Returns: Bool if you can move
  func move(offset: Int) -> Bool {
    index += offset
    if index < 0 {
      index = 0
      return false
    } else if index >= count {
      index = count - 1
      return false
    }
    return true
  }

  /// Save pin you currently focus on
  /// - Returns: Bool if you could save the current focusing pin on local DB
  func savePin() -> Bool {
    guard let unread = unread else {
      return false
    }
    if LDRPin.exists(link: unread.link, title: unread.title) {
      return true
    }
    if LDRPin.saveByAttributes(createdOn: Int(Date().timeIntervalSince1970), title: unread.title, link: unread.link) != nil {
      return false
    }
    URLSession.shared.publisher(for: .pinAdd(link: unread.linkUrl, title: unread.title))
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] result in
          if case let .failure(error) = result {
            self?.error = error
          }
        },
        receiveValue: { [weak self] response in
          if !response.isSuccess {
            self?.error = LDRError.failed("Failed to add a pin. (\(unread.link))")
          }
        }
      )
      .store(in: &pinAddCancellables)
    return true
  }
}
