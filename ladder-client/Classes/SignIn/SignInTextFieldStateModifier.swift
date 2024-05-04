import Combine
import SwiftUI

// MARK: - SignInTextFieldState

enum SignInTextFieldState {
    case error
    case focused
    case notFocused
}

// MARK: - SignInTextFieldStateModifier

struct SignInTextFieldStateModifier: ViewModifier {
    // MARK: - Private properties

    @State private var state: SignInTextFieldState = .notFocused {
        didSet {
            switch state {
            case .error:
                strokeColor = .red
            case .focused:
                strokeColor = .blue
            case .notFocused:
                strokeColor = .secondary
            }
        }
    }
    
    @State private var strokeColor: Color = .secondary
    
    // MARK: - Public properties
    
    let publisher: AnyPublisher<SignInTextFieldState, Never>
    
    // MARK: Public methods

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: CornerRadius.default)
                .stroke($strokeColor.wrappedValue, lineWidth: 1)
        )
        .onReceive(publisher) { state in
            self.state = state
        }
    }
}
