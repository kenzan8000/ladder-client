import SwiftUI
import UIKit

// MARK: - ActivityIndicator
struct ActivityIndicator: UIViewRepresentable {
  // MARK: property
  @Binding var isAnimating: Bool
  let style: UIActivityIndicatorView.Style
    
  // MARK: UIViewRepresentable
  func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
    UIActivityIndicatorView(style: style)
  }
    
  func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    if isAnimating {
      uiView.startAnimating()
    } else {
      uiView.stopAnimating()
    }
  }
    
  static func dismantleUIView(_ uiView: UIActivityIndicatorView, coordinator: ()) {
  }
}

// MARK: - ActivityIndicator_Previews
struct ActivityIndicator_Previews: PreviewProvider {
  static var previews: some View {
    GeometryReader { geometry in
      VStack {
        ActivityIndicator(
          isAnimating: .constant(true),
          style: .large
        )
      }
        .position(
          x: geometry.size.width / 2,
          y: geometry.size.height / 2
        )
    }
  }
}
