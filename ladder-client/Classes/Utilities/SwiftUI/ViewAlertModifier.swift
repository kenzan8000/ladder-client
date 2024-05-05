import Combine
import SwiftUI

// MARK: - ViewAlertModifier

struct ViewAlertModifier: ViewModifier {
    // MARK: - Private properties
    
    @State private var isPresented = false
    
    @State private var error: Error?
    
    // MARK: - Public properties
    
    let publisher: AnyPublisher<Error?, Never>
    
    // MARK: Public methods

    func body(content: Content) -> some View {
        content
            .alert(error?.localizedDescription ?? "", isPresented: $isPresented) {
                Button("OK") {
                    self.isPresented = false
                }
            }
            .onReceive(publisher) { error in
                self.error = error
                self.isPresented = error != nil
            }
    }
}
