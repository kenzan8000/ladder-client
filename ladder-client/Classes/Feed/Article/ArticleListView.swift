import SwiftUI

// MARK: - ArticleListView

struct ArticleListView: View {
    // MARK: - Private enums
    
    private enum Constant {
        static let titleLineLimit = 4
        static let buttonMinWidth: CGFloat = 128
        static let buttonMinHeight: CGFloat = 64
    }
    
    // MARK: - Private properties
    
    @State private var viewModel: ArticleListViewModel
    
    // MARK: - Public properties
    
    var body: some View {
        HStack {
            Spacer().frame(width: Spacing.default)
            VStack {
                Spacer().frame(height: Spacing.default)
                Text(viewModel.title)
                    .font(.title)
                    .foregroundStyle(.primary)
                    .lineLimit(Constant.titleLineLimit)
                    .truncationMode(.tail)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: Spacing.default)
                Text(viewModel.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .truncationMode(.tail)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
                Spacer().frame(height: Spacing.default)
                HStack {
                    Button(
                        action: { viewModel.goPrevious() },
                        label: {
                            Image(systemName: "chevron.left")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity)
                        }
                    )
                    Button(
                        action: { viewModel.goNext() },
                        label: {
                            Image(systemName: "chevron.right")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity)
                        }
                    )
                }
            }
            Spacer().frame(width: Spacing.default)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                    },
                    label: {
                        Text("Read later")
                        Image(systemName: "bookmark.fill")
                    }
                )
            }
        }
    }
    
    // MARK: - Init
    
    init(viewModel: ArticleListViewModel) {
        self.viewModel = viewModel
    }
}
