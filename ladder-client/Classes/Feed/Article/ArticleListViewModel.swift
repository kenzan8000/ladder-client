import Foundation

// MARK: - ArticleListViewModel

@Observable
final class ArticleListViewModel {
    // MARK: - Private properties
    
    private let articles: [Article]
    
    private var currentIndex: Int
    
    // MARK: - Public properties

    var canGoNext: Bool { currentIndex < (articles.count - 1) }
    
    var canGoPrevious: Bool { currentIndex > 0 }
    
    var title: String { "\(currentIndex + 1) / \(articles.count) - \(articles[currentIndex].title)" }
    
    var body: String { articles[currentIndex].body }
    
    // MARK: - Init
    
    init(
        articles: [Article],
        currentIndex: Int = 0
    ) {
        self.articles = articles
        self.currentIndex = currentIndex
    }
    
    // MARK: - Public methods
    
    func goNext() {
        guard canGoNext else {
            return
        }
        currentIndex += 1
    }
    
    func goPrevious() {
        guard canGoPrevious else {
            return
        }
        currentIndex -= 1
    }
}
