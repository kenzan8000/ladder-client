import Foundation
import SwiftUI

struct PinRowView: View {
    // MARK: - Private enums
    
    private enum Constant {
        static let minHeight: CGFloat = 64
        static let lineLimit = 2
    }
    
    // MARK: - Private properties
    
    @State private var viewModel: PinRowViewModel

    private let action: () -> Void

    // MARK: - Public properties

    var body: some View {
        Button(
            action: {
                viewModel.isWebViewPresented.toggle()
                action()
            },
            label: {
                Text(viewModel.text)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: Constant.minHeight, alignment: .leading)
                    .lineLimit(Constant.lineLimit)
                    .truncationMode(.tail)
            }
        )
        .sheet(isPresented: $viewModel.isWebViewPresented) {
            SafariView(url: viewModel.link)
        }
    }
    
    // MARK: - Init
    
    init(
        viewModel: PinRowViewModel,
        action: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.action = action
    }
}
