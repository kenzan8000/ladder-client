import SwiftUI

// MARK: - ArticleListView

struct ArticleListView: View {
    // MARK: - Private enums
    
    private enum Constant {
        // static let titleLineLimit = 4
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
                ArticleListTitleView(text: viewModel.title)
                Spacer().frame(height: Spacing.default)
                ArticleListBodyView(text: viewModel.body)
                Spacer()
                Spacer().frame(height: Spacing.default)
                ArticleListBottomButtonView(
                    canGoNext: viewModel.canGoNext,
                    canGoPrevious: viewModel.canGoPrevious,
                    leadingButtonAction: { viewModel.goPrevious() },
                    trailingButtonAction: { viewModel.goNext() }
                )
            }
            Spacer().frame(width: Spacing.default)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ArticleListAddPinButtonView { }
            }
        }
        .safeAreaPadding(.bottom)
    }
    
    // MARK: - Init
    
    init(viewModel: ArticleListViewModel) {
        self.viewModel = viewModel
    }
}
