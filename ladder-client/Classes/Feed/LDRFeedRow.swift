import Combine
import SwiftUI

// MARK: - LDRFeedRow
struct LDRFeedRow: View {
  // MARK: property

  var title: String
  var unreadCount: String
  var color: Color
  let tapPublisher = PassthroughSubject<Void, Never>()

  // MARK: property

  var body: some View {
    Button(
      action: {
        tapPublisher.send()
      },
      label: {
        HStack(spacing: 12) {
          Text(title)
            .lineLimit(1)
            .truncationMode(.tail)
            .foregroundColor(color)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
          Text(unreadCount)
            .lineLimit(1)
            .foregroundColor(color)
            .frame(alignment: .trailing)
          Image(systemName: "chevron.right")
            .foregroundColor(color)
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
  struct LDRFeedRowContent: Hashable {
    let title: String
    let unreadCount: String
    let color: Color
  }
  
  static var previews: some View {
    let contents = [
      LDRFeedRowContent(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", unreadCount: "187", color: .gray),
      LDRFeedRowContent(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", unreadCount: "187", color: .blue),
      LDRFeedRowContent(title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り", unreadCount: "", color: .gray)
    ]
    ForEach(contents, id: \.self) { content in
      LDRFeedRow(
        title: content.title,
        unreadCount: content.unreadCount,
        color: content.color
      )
    }
  }
}
