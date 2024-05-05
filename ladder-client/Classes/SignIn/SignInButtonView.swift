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

    @EnvironmentObject private var viewModel: SignInButtonViewModel
    
    /// State to define the button's design and content
    @State private var state: SignInButtonViewState = .signIn

    /// Action when clicking the button
    private let action: () -> Void
    
    // MARK: - Public properties

    var body: some View {
        Button(action: action) {
            SignInButtonContentView(state: $state)
                .frame(minWidth: Constant.minWidth, minHeight: Constant.minHeight)
        }
        .buttonStyle(BorderedButtonStyle())
        .onReceive(viewModel.statePublisher) { state in
            self.state = state
        }
    }
    
    // MARK: - Init
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
}
