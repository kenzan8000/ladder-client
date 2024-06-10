import SwiftUI

// MARK: - PinListView

struct PinListView: View {
    // MARK: - Private properties
    
    @State private var viewModel: PinListViewModel

    // MARK: - Public properties

    var body: some View {
        List(viewModel.pins) { pin in
            PinRowView(viewModel: PinRowViewModel(pin: pin)) {
                viewModel.remove(pin: pin)
            }
        }
        .listStyle(.plain)
        .refreshable { @MainActor in
            await viewModel.loadPins()
        }
    }
    
    // MARK: - Init
    
    init(viewModel: PinListViewModel) {
        self.viewModel = viewModel
    }
}
