import Foundation
import SwiftUI

struct FeedRowView: View {
    // MARK: - Private enums
    
    private enum Constant {
        static let titleLineLimit = 2
        static let numberOfArticlesLineLimit = 1
        static let minHeight: CGFloat = 64
    }
    
    // MARK: - Private properties
    
    @State private var viewModel: FeedRowViewModel
    
    private let action: () -> Void

    // MARK: - Public properties

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.default) {
                Text(viewModel.title)
                    .lineLimit(Constant.titleLineLimit)
                    .truncationMode(.tail)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .strikethrough(viewModel.isMarkedAsSeen, color: Color.secondary)
                Text(viewModel.numberOfArticles)
                    .lineLimit(Constant.numberOfArticlesLineLimit)
                    .frame(alignment: .trailing)
                Image(systemName: "chevron.right")
                    .font(.title)
                    .frame(alignment: .trailing)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: Constant.minHeight, alignment: .leading)
            .foregroundStyle(
                viewModel.hasArticles
                ? (viewModel.isMarkedAsSeen ? Color.secondary : Color.blue)
                : Color.secondary
            )
        }
    }
    
    // MARK: - Init
    
    init(
        viewModel: FeedRowViewModel,
        action: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.action = action
    }
}
