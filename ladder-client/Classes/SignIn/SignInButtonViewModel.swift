import Combine
import Foundation
import SwiftUI

// MARK: - SignInButtonViewModel

@Observable
final class SignInButtonViewModel {
    // MARK: - Private properties
    
    private let statePublisher: AnyPublisher<SignInButtonViewState, Never>

    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties

    /// State to define the button's design and content
    private(set) var state: SignInButtonViewState = .invaildForm

    // MARK: - Init
    
    init(
        isRootURLTextFieldValidPublisher: AnyPublisher<Bool, Never>,
        isUsernameTextFieldValidPublisher: AnyPublisher<Bool, Never>,
        isPasswordTextFieldValidPublisher: AnyPublisher<Bool, Never>,
        isSigningInPublisher: AnyPublisher<Bool, Never>
    ) {
        let isFormValid: AnyPublisher<Bool, Never> = Publishers.CombineLatest3(
            isRootURLTextFieldValidPublisher,
            isUsernameTextFieldValidPublisher,
            isPasswordTextFieldValidPublisher
        ).map { v1, v2, v3 -> Bool in
            v1 && v2 && v3
        }.eraseToAnyPublisher()
        self.statePublisher = Publishers.CombineLatest(
            isSigningInPublisher,
            isFormValid
        ).map { (isSigningIn: Bool, isFormValid: Bool) -> SignInButtonViewState in
            guard !isSigningIn else {
                return .loading
            }
            return isFormValid ? .signIn : .invaildForm
        }.eraseToAnyPublisher()
        self.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (state: SignInButtonViewState) in self?.state = state }
            .store(in: &self.cancellables)
    }
}
