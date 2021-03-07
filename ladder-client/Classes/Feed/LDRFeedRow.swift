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
          .frame(height: 64)
          .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
      }
    )
  }
  
  // MARK: public api
  
  func onTap(perform action: @escaping () -> Void) -> some View {
    onReceive(tapPublisher) { action() }
  }
}

// MARK: - LDRFeedRowUnload_Previews
struct LDRFeedRowUnload_Previews: PreviewProvider {
  static var previews: some View {
    LDRFeedRow(
      title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り",
      unreadCount: "187",
      color: .gray
    )
  }
}

// MARK: - LDRFeedRowUnread_Previews
struct LDRFeedRowUnread_Previews: PreviewProvider {
  static var previews: some View {
    LDRFeedRow(
      title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り",
      unreadCount: "187",
      color: .blue
    )
  }
}

// MARK: - LDRFeedRowRead_Previews
struct LDRFeedRowRead_Previews: PreviewProvider {
  static var previews: some View {
    LDRFeedRow(
      title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り",
      unreadCount: "",
      color: .gray
    )
  }
}
