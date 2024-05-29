import SwiftUI

// MARK: - RootSignInButtonView

struct RootSignInButtonView: View {
    // MARK: - Private properties
    
    @EnvironmentObject private var viewModel: RootSignInButtonViewModel

    @State private var isSignedIn = false
    
    /// Action when presenting sign in view
    private let action: () -> Void
    
    // MARK: - Public properties

    var body: some View {
        Button(
            action: action,
            label: {
                if isSignedIn {
                    Image(systemName: "person.crop.circle.badge.minus")
                    Text("Sign out")
                } else {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("Sign in")
                }
            }
        )
        .onReceive(viewModel.isSignedInPublisher) { isSignedIn = $0 }
    }
    
    // MARK: - Init
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
}
