import Combine
import SwiftyJSON
import SwiftUI
import WebKit

// MARK: - LDRFeedDetailViewModel
final class LDRFeedDetailViewModel: ObservableObject {
    
  // MARK: property
  @Published var unread: LDRFeedUnread
  @Published var index: Int = 0
  var count: Int { unread.items.count }
  var title: String { unread.getTitle(at: index) ?? "" }
  var body: String { unread.getBody(at: index) ?? "" }
  var link: URL { unread.getLink(at: index) ?? URL(fileURLWithPath: "") }
  var prevTitle: String { unread.getTitle(at: index - 1) ?? "" }
  var nextTitle: String { unread.getTitle(at: index + 1) ?? "" }
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
    
  init(unread: LDRFeedUnread) {
    self.unread = unread
    NotificationCenter.default.publisher(for: LDRNotificationCenter.didLogin)
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
    let url = link
    if LDRPin.exists(link: url.absoluteString, title: title) {
      return true
    }
    if LDRPin.saveByAttributes(createdOn: "", title: title, link: url.absoluteString) != nil {
      return false
    }
    URLSession.shared.publisher(for: .pinAdd(link: url, title: title))
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] result in
          if case let .failure(error) = result {
            self?.error = error
          }
        },
        receiveValue: { [weak self] response in
          if !response.isSuccess {
            self?.error = LDRError.failed("Failed to add a pin. (\(url.absoluteString))")
          }
        }
      )
      .store(in: &pinAddCancellables)
    return true
  }
}
