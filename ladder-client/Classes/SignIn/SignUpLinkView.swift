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
                .onReceive(viewModel.statePublisher) { state in
                    self.state = state
                }
        } else {
            Button("Sign up") { }
                .disabled(true)
                .onReceive(viewModel.statePublisher) { state in
                    self.state = state
                }
        }
    }
}
