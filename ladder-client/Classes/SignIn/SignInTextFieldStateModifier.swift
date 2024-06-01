import Combine
import SwiftUI

// MARK: - SignInTextFieldState

enum SignInTextFieldState {
    case error
    case focused
    case notFocused
    
    var strokeColor: Color {
        switch self {
        case .error:
            return .red
        case .focused:
            return .blue
        case .notFocused:
            return .secondary
        }
    }
}

// MARK: - SignInTextFieldStateModifier

struct SignInTextFieldStateModifier: ViewModifier {
    // MARK: - Public properties
    
    @Binding var state: SignInTextFieldState
    
    // MARK: Public methods

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: CornerRadius.default)
                .stroke(state.strokeColor, lineWidth: 1)
        )
    }
}
