import SwiftUI

// MARK: - ArticleListTitleView

struct ArticleListTitleView: View {
    // MARK: - Private enums
    
    private enum Constant {
        static let lineLimit = 4
    }
    
    // MARK: - Public properties
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundStyle(.primary)
            .lineLimit(Constant.lineLimit)
            .truncationMode(.tail)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}
