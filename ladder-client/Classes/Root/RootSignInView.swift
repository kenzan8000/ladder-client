import SwiftUI

// MARK: - RootSignInView

struct RootSignInView: View {
    // MARK: - Private enums
    
    private enum Constant {
        static let minWidth: CGFloat = 128
        static let minHeight: CGFloat = 32
    }

    // MARK: - Private properties
    
    @State private var viewModel: RootSignInViewModel
    
    // MARK: - Public properties

    var body: some View {
        HStack {
            Spacer().frame(width: Spacing.default)
            VStack {
                Spacer().frame(height: Spacing.double)
                VStack(alignment: .leading) {
                    Text("Let's get started with Fastladder client!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Spacer().frame(height: Spacing.default)
                VStack(alignment: .leading) {
                    Text("\"**[Fastladder](https://github.com/fastladder/fastladder)**\" is the best opensource RSS Reader for feed-hungry people to consume more articles from RSS/Atom feeds. Please set up your Fastladder settings.")
                        .foregroundStyle(.secondary)
                }
                Spacer().frame(height: Spacing.double)
                Button(
                    action: { viewModel.isSignInViewPresented.toggle() },
                    label: {
                        Text("Start")
                            .frame(minWidth: Constant.minWidth, minHeight: Constant.minHeight)
                    }
                ).buttonStyle(BorderedButtonStyle())
                Spacer()
            }
            Spacer().frame(width: Spacing.default)
        }
        .sheet(isPresented: $viewModel.isSignInViewPresented) {
            SignInNavigationView(viewModel: viewModel.signInNavigationViewModel)
        }
    }
    
    // MARK: - Init
    
    init(viewModel: RootSignInViewModel) {
        self.viewModel = viewModel
    }
}
