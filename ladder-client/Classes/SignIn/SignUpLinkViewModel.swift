import Combine
import Foundation

// MARK: - SignUpLinkViewModel

final class SignUpLinkViewModel: ObservableObject {
    // MARK: - Public properties

    let statePublisher: AnyPublisher<SignUpLinkViewState, Never>

    // MARK: - Init

    init(statePublisher: AnyPublisher<SignUpLinkViewState, Never>) {
        self.statePublisher = statePublisher
    }
}
