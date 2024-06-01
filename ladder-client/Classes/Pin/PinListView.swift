import SwiftUI

// MARK: - PinListView

struct PinListView: View {
    // MARK: - Private properties
    
    @State private var viewModel: PinListViewModel

    // MARK: - Public properties

    var body: some View {
        List(viewModel.pins) { _ in
            Text("foo")
        }
        .listStyle(.plain)
        .refreshable {
        }
    }
    
    // MARK: - Init
    
    init(viewModel: PinListViewModel) {
        self.viewModel = viewModel
    }
}
