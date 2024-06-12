import SwiftUI

// MARK: - RootNavigationView

struct RootNavigationView<Content>: View where Content: View {
    // MARK: - Private properties
    
    @State private var viewModel: RootNavigationViewModel
    
    @ViewBuilder private let content: () -> Content
    
    // MARK: - Public properties

    var body: some View {
        NavigationView {
            VStack(content: content)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        RootSignInButtonView(viewModel: viewModel.rootSignInButtonViewModel) {
                            if viewModel.isSignedIn {
                                viewModel.signOut()
                            } else {
                                viewModel.isSignInViewPresented.toggle()
                            }
                        }
                    }
                    if viewModel.isSignedIn {
                        ToolbarItem(placement: .topBarTrailing) {
                            RootLoadButtonView(viewModel: viewModel.rootLoadButtonViewModel)
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isSignInViewPresented) {
                    SignInNavigationView(viewModel: viewModel.signInNavigationViewModel)
                }
        }
    }
    
    // MARK: - Init

    init(
        viewModel: RootNavigationViewModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content
    }
}
