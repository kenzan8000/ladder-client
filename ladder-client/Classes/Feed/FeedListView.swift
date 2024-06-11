import SwiftUI

// MARK: - FeedListView

struct FeedListView: View {
    // MARK: - Private properties
    
    @State private var viewModel: FeedListViewModel

    // MARK: - Public properties

    var body: some View {
        List(viewModel.feeds) { feed in
            FeedRowView(viewModel: FeedRowViewModel(feed: feed)) {
            }
        }
        .listStyle(.plain)
        .refreshable { @MainActor in
            await viewModel.loadFeeds()
        }
    }
    
    // MARK: - Init
    
    init(viewModel: FeedListViewModel) {
        self.viewModel = viewModel
    }
}
