import Foundation

// MARK: - ArticleListViewModel

@Observable
final class ArticleListViewModel {
    // MARK: - Private properties
    
    private let pinService: any PinServiceProtocol
    
    private let pinStorage: any PinStorageProtocol
    
    private let articles: [Article]
    
    private var currentIndex: Int
    
    // MARK: - Public properties

    var canGoNext: Bool { currentIndex < (articles.count - 1) }
    
    var canGoPrevious: Bool { currentIndex > 0 }
    
    var title: String { "\(currentIndex + 1) / \(articles.count) - \(articles[currentIndex].title)" }
    
    var body: String { articles[currentIndex].body }
    
    var isPinAdded: Bool {
        pinStorage.hasPin(url: articles[currentIndex].link)
    }
    
    // MARK: - Init
    
    init(
        pinService: any PinServiceProtocol,
        pinStorage: any PinStorageProtocol,
        articles: [Article],
        currentIndex: Int = 0
    ) {
        self.pinService = pinService
        self.pinStorage = pinStorage
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
    
    func addPin() {
        Task { @MainActor [weak self] in
            guard let self, let link = self.articles[currentIndex].link else {
                return
            }
            let title = self.articles[currentIndex].title
            _ = await self.pinService.addPin(title: title, link: link)
            self.currentIndex = self.currentIndex
        }
    }
}
