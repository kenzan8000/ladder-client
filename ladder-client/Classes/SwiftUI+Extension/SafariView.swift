import SafariServices
import SwiftUI
import UIKit

// MARK: - SafariView
struct SafariView: UIViewControllerRepresentable {
  // MARK: property
  let url: URL

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
