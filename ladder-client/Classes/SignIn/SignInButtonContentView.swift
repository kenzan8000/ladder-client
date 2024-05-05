import SwiftUI

// MARK: - SignInButtonContentView

struct SignInButtonContentView: View {
    // MARK: - Public properties
    
    @Binding var state: SignInButtonViewState
    
    var body: some View {
        switch state {
        case .invaildForm:
            Text("Sign in")
                .foregroundStyle(.secondary)
        case .loading:
            ProgressView()
        case .signIn:
            Text("Sign in")
                .foregroundStyle(.primary)
        }
    }
}
