import SwiftUI

// MARK: - ArticleListAddPinButtonView

struct ArticleListAddPinButtonView: View {
    // MARK: - Private properties
    
    private let isPinAdded: Bool
    
    private let action: () -> Void
    
    // MARK: - Public properties
    
    var body: some View {
        Button(action: action) {
            Text(isPinAdded ? "Saved" : "Read Later")
            Image(systemName: isPinAdded ? "bookmark.fill" : "bookmark")
        }
    }
    
    // MARK: - Init
    
    init(isPinAdded: Bool, action: @escaping () -> Void) {
        self.isPinAdded = isPinAdded
        self.action = action
    }
}
