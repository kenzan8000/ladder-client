import SwiftUI

// MARK: - SignInView

struct SignInView: View {
    // MARK: - Public properties

    var body: some View {
        VStack {
            SignInDomainTextFieldView()
                .environmentObject(SignInDomainTextFieldViewModel())
            SignInUsernameTextFieldView()
                .environmentObject(SignInUsernameTextFieldViewModel())
        }
    }
}
