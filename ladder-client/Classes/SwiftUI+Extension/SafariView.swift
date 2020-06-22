import SafariServices
import SwiftUI
import UIKit

struct SafariView: UIViewControllerRepresentable {
    let url: URL

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
