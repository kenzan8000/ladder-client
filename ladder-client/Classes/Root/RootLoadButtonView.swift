import SwiftUI

// MARK: - RootLoadButtonView

struct RootLoadButtonView: View {
    // MARK: - Private properties
    
    @State private var viewModel: RootLoadButtonViewModel
    
    /// Action when presenting sign in view
    private let action: () -> Void
    
    // MARK: - Public properties

    var body: some View {
        if viewModel.isLoading {
            HStack {
                Text("Loading")
                    .foregroundStyle(.secondary)
                Spacer().frame(width: Spacing.small)
                ProgressView()
            }
        } else {
            Button(action: action) {
                Text("Reload")
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    
    // MARK: - Init
    
    init(
        viewModel: RootLoadButtonViewModel,
        action: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.action = action
    }
}
