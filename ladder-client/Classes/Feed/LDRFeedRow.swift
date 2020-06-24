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
                    
                    Text(unreadCount)
                    .lineLimit(1)
                    .foregroundColor(color)
                    
                    Image(uiImage: IonIcons.image(
                            withIcon: ion_chevron_right,
                            iconColor: UIColor.systemGray,
                            iconSize: 24,
                            imageSize: CGSize(width: 24, height: 24)
                        )
                    )
                }
                .frame(height: 48)
                .padding(12)
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
