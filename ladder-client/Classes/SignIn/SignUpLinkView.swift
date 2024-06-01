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
    
    @State private var viewModel: SignUpLinkViewModel
    
    // MARK: - Public properties

    var body: some View {
        if let url = viewModel.state.url {
            Link("Sign up", destination: url)
                .opacity(viewModel.state.opacity)
        } else {
            Button("Sign up") { }
                .opacity(viewModel.state.opacity)
        }
    }
    
    // MARK: - Init
    
    init(viewModel: SignUpLinkViewModel) {
        self.viewModel = viewModel
    }
}
