import SwiftUI

// MARK: - RootNavigationView

struct RootNavigationView<Content>: View where Content: View {
    // MARK: - Private properties
    
    @EnvironmentObject private var viewModel: RootNavigationViewModel

    @State private var isSignedIn = false
    
    @State private var isSignInViewPresented = false
    
    @ViewBuilder private let content: () -> Content
    
    // MARK: - Public properties

    var body: some View {
        NavigationView {
            VStack(content: content)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        RootSignInButtonView {
                            if isSignedIn {
                                viewModel.signOut()
                            } else {
                                isSignInViewPresented.toggle()
                            }
                        }
                        .environmentObject(viewModel.makeRootSignInButtonViewModel())
                    }
                    if isSignedIn {
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
                }
                .sheet(isPresented: $isSignInViewPresented) {
                    SignInNavigationView()
                        .environmentObject(viewModel.makeSignInNavigationViewModel())
                }
                .onReceive(viewModel.isSignedInPublisher) { isSignedIn = $0 }
        }
    }
    
    // MARK: - Init

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
}
