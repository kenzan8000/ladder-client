import SwiftUI

// MARK: - SignInButtonView

struct SignInButtonView: View {
    // MARK: - Private enums
    
    private enum Constant {
        static let minWidth: CGFloat = 128
        static let minHeight: CGFloat = 32
    }
    
    // MARK: - Private properties

    @EnvironmentObject private var viewModel: SignInButtonViewModel
    
    private let action: () -> Void
    
    // MARK: - Public properties

    var body: some View {
        Button(action: action) {
            Text("Sign in")
                .frame(minWidth: Constant.minWidth, minHeight: Constant.minHeight)
        }
        .buttonStyle(BorderedButtonStyle())
    }
    
    // MARK: - Init
    
    init(action: @escaping () -> Void) {
        self.action = action
    }

}
