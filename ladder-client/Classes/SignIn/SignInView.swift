import SwiftUI

// MARK: - SignInView

struct SignInView: View {
    // MARK: - Public properties

    var body: some View {
        VStack {
            Spacer().frame(height: Spacing.default)

            SignInDomainTextFieldView()
                .environmentObject(SignInDomainTextFieldViewModel())

            Spacer().frame(height: Spacing.tight)

            SignInUsernameTextFieldView()
                .environmentObject(SignInUsernameTextFieldViewModel())

            Spacer().frame(height: Spacing.tight)
                
            SignInPasswordTextFieldView()
                .environmentObject(SignInPasswordTextFieldViewModel())
            
            Spacer().frame(height: Spacing.double)
                
            SignInButtonView()
                .environmentObject(SignInButtonViewModel())

            Spacer()
        }
        .padding(.horizontal)
    }
}
