import Combine
import Foundation

// MARK: - SignInButtonViewModel

final class SignInButtonViewModel: ObservableObject {
    // MARK: - Public properties

    let statePublisher: AnyPublisher<SignInButtonViewState, Never>

    // MARK: - Init

    init(statePublisher: AnyPublisher<SignInButtonViewState, Never>) {
        self.statePublisher = statePublisher
    }
}
