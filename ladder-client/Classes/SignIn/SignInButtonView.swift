import SwiftUI

// MARK: - SignInButtonViewState

enum SignInButtonViewState {
    case invaildForm
    case loading
    case signIn
}

// MARK: - SignInButtonView

struct SignInButtonView: View {
    // MARK: - Private enums
    
    private enum Constant {
        static let minWidth: CGFloat = 128
        static let minHeight: CGFloat = 32
    }
    
    // MARK: - Private properties

    @State private var viewModel: SignInButtonViewModel

    private let action: () -> Void
    
    // MARK: - Public properties

    var body: some View {
        Button(action: action) {
            switch viewModel.state {
            case .invaildForm:
                Text("Sign in")
                    .foregroundStyle(.secondary)
                    .frame(minWidth: Constant.minWidth, minHeight: Constant.minHeight)
            case .loading:
                ProgressView()
                    .frame(minWidth: Constant.minWidth, minHeight: Constant.minHeight)
            case .signIn:
                Text("Sign in")
                    .foregroundStyle(.primary)
                    .frame(minWidth: Constant.minWidth, minHeight: Constant.minHeight)
            }
        }
        .buttonStyle(BorderedButtonStyle())
    }
    
    // MARK: - Init
    
    init(
        viewModel: SignInButtonViewModel,
        action: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.action = action
    }
}
