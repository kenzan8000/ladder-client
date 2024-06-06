import SwiftUI

// MARK: - RootLoadButtonView

struct RootLoadButtonView: View {
    // MARK: - Private properties
    
    @State private var viewModel: RootLoadButtonViewModel
    
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
            Button(
                action: {
                    viewModel.reload()
                },
                label: {
                    Text("Reload")
                    Image(systemName: "arrow.clockwise")
                }
            )
        }
    }
    
    // MARK: - Init
    
    init(viewModel: RootLoadButtonViewModel) {
        self.viewModel = viewModel
    }
}
