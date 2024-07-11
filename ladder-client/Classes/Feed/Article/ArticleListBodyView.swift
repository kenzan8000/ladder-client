import SwiftUI

// MARK: - ArticleListBodyView

struct ArticleListBodyView: View {
    // MARK: - Public properties
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.body)
            .foregroundStyle(.secondary)
            .truncationMode(.tail)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}
