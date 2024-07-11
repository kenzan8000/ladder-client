import SwiftUI

// MARK: - ArticleListBottomButtonView

struct ArticleListBottomButtonView: View {
    // MARK: - Private properties
    
    private let canGoPrevious: Bool

    private let canGoNext: Bool
    
    private var leadingButtonForegroundStyle: Color {
        canGoPrevious ? .blue : .secondary
    }
    
    private var trailingButtonForegroundStyle: Color {
        canGoNext ? .blue : .secondary
    }

    private let leadingButtonAction: () -> Void
    
    private let trailingButtonAction: () -> Void

    // MARK: - Public properties
    
    var body: some View {
        HStack {
            Button(action: leadingButtonAction) {
                VStack {
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                    Spacer().frame(height: Spacing.minimal)
                    Text("Previous")
                        .font(.caption)
                }
            }
            .foregroundStyle(leadingButtonForegroundStyle)
            Button(action: trailingButtonAction) {
                VStack {
                    Image(systemName: "chevron.right")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                    Spacer().frame(height: Spacing.minimal)
                    Text("Next")
                        .font(.caption)
                }
            }
            .foregroundStyle(trailingButtonForegroundStyle)
        }
    }
    
    // MARK: - Init
    
    init(
        canGoPrevious: Bool,
        canGoNext: Bool,
        leadingButtonAction: @escaping () -> Void,
        trailingButtonAction: @escaping () -> Void
    ) {
        self.canGoPrevious = canGoPrevious
        self.canGoNext = canGoNext
        self.leadingButtonAction = leadingButtonAction
        self.trailingButtonAction = trailingButtonAction
    }
}
