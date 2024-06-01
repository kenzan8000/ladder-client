import SwiftUI

// MARK: - SignInNavigationView

struct SignInNavigationView: View {
    // MARK: - Private properties

    @State private var viewModel: SignInNavigationViewModel

    @Environment(\.dismiss)
    private var dismiss

    // MARK: - Public properties

    var body: some View {
        NavigationView {
            SignInView(viewModel: viewModel.makeSignInViewModel())
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(
                            action: { dismiss() },
                            label: { Image(systemName: "chevron.down") }
                        )
                    }
                }
        }
    }
    
    // MARK: - Init
    
    init(viewModel: SignInNavigationViewModel) {
        self.viewModel = viewModel
    }
}
