import SwiftUI

// MARK: - LDRFeedRow
struct LDRFeedRow: View {
    var title: String
    var unreadCount: String
    var color: Color
    var onTap: (() -> Void)?
    
    var body: some View {
        Button(
            action: {
                if let onTap = self.onTap {
                    onTap()
                }
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
                    
                    Image(uiImage: IonIcons.image(
                            withIcon: ion_chevron_right,
                            iconColor: UIColor.systemGray,
                            iconSize: 24,
                            imageSize: CGSize(width: 24, height: 24)
                        )
                    )
                    .frame(alignment: .trailing)
                }
                .frame(height: 64)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            }
        )
    }
}

// MARK: - LDRFeedRow_Previews
struct LDRFeedRow_Previews: PreviewProvider {
    static var previews: some View {
        LDRFeedRow(
            title: "はてなブックマーク -kenzan8000 のブックマーク - お気に入り",
            unreadCount: "187",
            color: Color.gray
        )
    }
}
