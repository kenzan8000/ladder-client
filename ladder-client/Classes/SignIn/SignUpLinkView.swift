import SwiftUI

// MARK: - SignUpLinkViewState

enum SignUpLinkViewState {
    case disabled
    case enabled(URL?)
    
    var url: URL? {
        switch self {
        case .disabled:
            return nil
        case let .enabled(url):
            return url
        }
    }

    var opacity: CGFloat {
        switch self {
        case .disabled:
            return 0.5
        case .enabled:
            return 1
        }
    }
}

// MARK: - SignUpLinkView

struct SignUpLinkView: View {
    // MARK: - Private properties
    
    @EnvironmentObject private var viewModel: SignUpLinkViewModel

    @State private var state: SignUpLinkViewState = .disabled
    
    // MARK: - Public properties

    var body: some View {
        if let url = $state.wrappedValue.url {
            Link("Sign up", destination: url)
                .opacity($state.wrappedValue.opacity)
                .onReceive(viewModel.statePublisher) { state in
                    self.state = state
                }
        } else {
            Button("Sign up") { }
                .opacity($state.wrappedValue.opacity)
                .onReceive(viewModel.statePublisher) { state in
                    self.state = state
                }
        }
    }
}
