import Combine
import Foundation

// MARK: - SignInButtonViewModel

class SignInButtonViewModel: ObservableObject {
    // MARK: - Public properties

    let statePublisher: AnyPublisher<SignInButtonViewState, Never>

    // MARK: - Init

    init(statePublisher: AnyPublisher<SignInButtonViewState, Never>) {
        self.statePublisher = statePublisher
    }
}
