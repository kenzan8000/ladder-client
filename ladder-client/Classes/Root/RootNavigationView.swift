import SwiftUI

// MARK: - RootNavigationView

struct RootNavigationView<Content>: View where Content: View {
    // MARK: - Private properties

    @State private var isSignInViewPresented = false
    
    private let content: () -> Content
    
    // MARK: - Public properties

    var body: some View {
        NavigationView {
            VStack(content: content)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(
                            action: { isSignInViewPresented.toggle() },
                            label: {
                                Image(systemName: "person.crop.circle")
                                Text("Sign in")
                            }
                        )
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(
                            action: { },
                            label: {
                                Text("Reload")
                                Image(systemName: "arrow.clockwise")
                            }
                        )
                    }
                }
                .sheet(isPresented: $isSignInViewPresented) { SignInView() }
        }
    }
    
    // MARK: - Init

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
}
