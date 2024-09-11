import SwiftUI

// MARK: - ArticleListView

struct ArticleListView: View {
    // MARK: - Private enums
    
    private enum Constant {
        static let buttonMinWidth: CGFloat = 128
        static let buttonMinHeight: CGFloat = 64
    }
    
    // MARK: - Private properties
    
    @State private var viewModel: ArticleListViewModel
   
    private var window: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }
    }
    
    // MARK: - Public properties
    
    var body: some View {
        HStack {
            Spacer().frame(width: Spacing.default)
            VStack {
                Spacer().frame(height: Spacing.default)
                ArticleListTitleView(text: viewModel.title)
                Spacer().frame(height: Spacing.default)
                ScrollView {
                    ArticleListBodyView(text: viewModel.body)
                }
                Spacer()
                Spacer().frame(height: Spacing.default)
                ArticleListBottomButtonView(
                    canGoPrevious: viewModel.canGoPrevious,
                    canGoNext: viewModel.canGoNext,
                    leadingButtonAction: {
                        if !viewModel.canGoPrevious, let window {
                            BlinkView().startAnimating(on: window)
                        }
                        viewModel.goPrevious()
                    },
                    trailingButtonAction: {
                        if !viewModel.canGoNext, let window {
                            BlinkView().startAnimating(on: window)
                        }
                        viewModel.goNext()
                    }
                )
            }
            Spacer().frame(width: Spacing.default)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ArticleListPinButtonView(isPinAdded: viewModel.isPinAdded) {
                    viewModel.updatePin()
                }
            }
        }
        .safeAreaPadding(.bottom)
    }
    
    // MARK: - Init
    
    init(viewModel: ArticleListViewModel) {
        self.viewModel = viewModel
    }
}
