import SwiftUI

// MARK: - FeedListView

struct FeedListView: View {
    // MARK: - Private properties
    
    @State private var viewModel: FeedListViewModel
    
    // MARK: - Public properties

    var body: some View {
        List(viewModel.articleFeeds) { (articleFeed: ArticleFeed) in
            FeedRowView(viewModel: FeedRowViewModel(articleFeed: articleFeed)) {
                viewModel.setSelectedArticleFeedIfNeeded(articleFeed)
            }
        }
        .listStyle(.plain)
        .navigationDestination(item: $viewModel.selectedArticleFeed) { (articleFeed: ArticleFeed) in
            ArticleListView(viewModel: viewModel.makeArticleListViewModel(articles: articleFeed.articles))
        }
        .refreshable { @MainActor in
            await viewModel.loadFeeds()
        }
    }
    
    // MARK: - Init
    
    init(viewModel: FeedListViewModel) {
        self.viewModel = viewModel
    }
}
