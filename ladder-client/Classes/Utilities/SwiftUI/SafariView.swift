import Foundation
import SafariServices
import SwiftUI

// MARK: - SafariView

struct SafariView: UIViewControllerRepresentable {
    // MARK: Private properties
    
    private let url: URL
    
    // MARK: - Init
    
    init(url: URL) {
        self.url = url
    }

    // MARK: UIViewControllerRepresentable
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {
    }
}
