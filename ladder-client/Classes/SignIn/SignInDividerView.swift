import SwiftUI

// MARK: - SignInDividerView

struct SignInDividerView: View {
    // MARK: - Private enums
    
    private enum Constant {
        static let maxHeight: CGFloat = 16
    }

    // MARK: - Public properties
    
    var body: some View {
        HStack {
            Spacer().frame(width: Spacing.default)
            VStack {
                Divider()
            }
            Spacer().frame(width: Spacing.default)
            Text("or").foregroundStyle(.separator)
            Spacer().frame(width: Spacing.default)
            VStack {
                Divider()
            }
            Spacer().frame(width: Spacing.default)
        }
        .frame(maxHeight: Constant.maxHeight)
    }
}
