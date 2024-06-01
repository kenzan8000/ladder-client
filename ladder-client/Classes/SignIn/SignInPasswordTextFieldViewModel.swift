import Combine
import Foundation

// MARK: - SignInPasswordTextFieldViewModel

@Observable
final class SignInPasswordTextFieldViewModel {
    // MARK: - Private properties
    
    private var isFocused = false

    private var hasAttemptedSigningIn = false
    
    private let isValidSubject: CurrentValueSubject<Bool, Never>

    // MARK: - Public properties

    /// Input password on the textfield
    var password = "" {
        didSet {
            isValid = !password.isEmpty
            updateState()
        }
    }

    /// State to define the text field design
    var state: SignInTextFieldState = .notFocused
    
    /// Is the input password valid?
    private(set) var isValid: Bool {
        get { isValidSubject.value }
        set { isValidSubject.send(newValue) }
    }
    
    let isValidPublisher: AnyPublisher<Bool, Never>
    
    // MARK: - Init
    
    init() {
        let isVaildSubject = CurrentValueSubject<Bool, Never>(false)
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
