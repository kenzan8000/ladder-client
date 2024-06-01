import SwiftUI

// MARK: - RootSignInButtonView

struct RootSignInButtonView: View {
    // MARK: - Private properties
    
    @State private var viewModel: RootSignInButtonViewModel
    
    /// Action when presenting sign in view
    private let action: () -> Void
    
    // MARK: - Public properties

    var body: some View {
        Button(action: action) {
            if viewModel.isSignedIn {
                Image(systemName: "person.crop.circle.badge.minus")
                Text("Sign out")
            } else {
                Image(systemName: "person.crop.circle.badge.plus")
                Text("Sign in")
            }
        }
    }
    
    // MARK: - Init
    
    init(
        viewModel: RootSignInButtonViewModel,
        action: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.action = action
    }
}
