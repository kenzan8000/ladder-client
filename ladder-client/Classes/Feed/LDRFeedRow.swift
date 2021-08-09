import Combine
import SwiftUI

// MARK: - LDRFeedRow
struct LDRFeedRow: View {
  // MARK: property

  let viewModel: ViewModel
  let tapPublisher = PassthroughSubject<Void, Never>()

  // MARK: property

  var body: some View {
    Button(
      action: {
        tapPublisher.send()
      },
      label: {
        HStack(spacing: 12) {
          Text(viewModel.title)
            .lineLimit(1)
            .truncationMode(.tail)
            .foregroundColor(viewModel.color)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
          Text(viewModel.unreadCount)
            .lineLimit(1)
            .foregroundColor(viewModel.color)
            .frame(alignment: .trailing)
          Image(systemName: "chevron.right")
            .foregroundColor(viewModel.color)
            .font(.title)
            .frame(alignment: .trailing)
        }
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 64, alignment: .leading)
          .padding(.horizontal, 16.0)
      }
    )
  }
  
  // MARK: public api
  
  func onTap(perform action: @escaping () -> Void) -> some View {
    onReceive(tapPublisher) { action() }
  }
}

// MARK: - LDRFeedRowUnload_Previews
struct LDRFeedRow_Previews: PreviewProvider {
  // MARK: LDRFeedRowContent
  struct LDRFeedRowContent: FeedSubsUnread, Hashable {
    let title: String
    var unreadCount: Int
    let state: LDRFeedSubsUnreadState
  }
  
  // MARK: static property
  static var previews: some View {
    let contents: [LDRFeedRowContent] = [
      .init(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", unreadCount: 187, state: .unloaded),
      .init(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", unreadCount: 187, state: .unread),
      .init(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", unreadCount: 187, state: .read)
    ]
    ForEach(contents, id: \.self) { content in
      LDRFeedRow(viewModel: .init(subsunread: content))
    }
  }
}
