import Combine
import SwiftUI

// MARK: - ViewAlertModifier

struct ViewAlertModifier: ViewModifier {
    // MARK: - Private properties
    
    @State private var isPresented = false
    
    // MARK: - Public properties
    
    @State private(set) var error: Error? {
        didSet { isPresented = (error != nil) }
    }
   
    // MARK: Public methods

    func body(content: Content) -> some View {
        content
            .alert(error?.localizedDescription ?? "", isPresented: $isPresented) {
                Button("OK") {
                    self.isPresented = false
                }
            }
    }
}
