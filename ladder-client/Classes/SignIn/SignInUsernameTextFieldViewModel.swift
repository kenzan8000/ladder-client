import Combine
import Foundation

// MARK: - SignInUsernameTextFieldViewModel

@Observable
final class SignInUsernameTextFieldViewModel {
    // MARK: - Private properties
    
    private var isFocused = false

    private var hasAttemptedSigningIn = false
    
    private let isValidSubject: CurrentValueSubject<Bool, Never>
    
    // MARK: - Public properties

    /// Input username on the textfield
    var username = "" {
        didSet {
            isValid = !username.isEmpty
            updateState()
        }
    }

    /// State to define the text field design
    var state: SignInTextFieldState = .notFocused
    
    /// Is the input username valid?
    private(set) var isValid: Bool {
        didSet {
            isValidSubject.send(isValid)
        }
    }
    
    let isValidPublisher: AnyPublisher<Bool, Never>
    
    // MARK: - Init
    
    init() {
        let isValid = false
        self.isValid = isValid
        let isVaildSubject = CurrentValueSubject<Bool, Never>(isValid)
        self.isValidSubject = isVaildSubject
        self.isValidPublisher = isValidSubject.eraseToAnyPublisher()
    }

    // MARK: - Private methods

    private func updateState() {
        let shouldShowError = hasAttemptedSigningIn && !isValid
        if shouldShowError {
            state = .error
        } else {
            state = isFocused ? .focused : .notFocused
        }
    }

    // MARK: - Public methods

    func updateState(isFocused: Bool, hasAttemptedSigningIn: Bool) {
        self.isFocused = isFocused
        self.hasAttemptedSigningIn = hasAttemptedSigningIn
        updateState()
    }
}
