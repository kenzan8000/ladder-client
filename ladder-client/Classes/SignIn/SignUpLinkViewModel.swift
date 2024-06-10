import Combine
import Foundation

// MARK: - SignUpLinkViewModel

@Observable
final class SignUpLinkViewModel {
    // MARK: - Private properties

    private let publisher: AnyPublisher<SignUpLinkViewState, Never>
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    
    private(set) var state: SignUpLinkViewState = .disabled

    // MARK: - Init

    init(publisher: AnyPublisher<SignUpLinkViewState, Never>) {
        self.publisher = publisher
        self.publisher.receive(on: DispatchQueue.main)
            .sink { [weak self] (state: SignUpLinkViewState) in
                self?.state = state
            }
            .store(in: &self.cancellables)
    }
}
