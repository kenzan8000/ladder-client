import SwiftUI

// MARK: - ArticleListAddPinButtonView

struct ArticleListAddPinButtonView: View {
    // MARK: - Private properties
    
    let action: () -> Void
    
    // MARK: - Public properties
    
    var body: some View {
        Button(action: action) {
            Text("Read Later")
            Image(systemName: "bookmark.fill")
        }
    }
    
    // MARK: - Init
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
}
