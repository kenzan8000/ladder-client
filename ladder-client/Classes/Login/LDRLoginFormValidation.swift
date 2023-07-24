import Combine
import SwiftUI

// MARK: - LDRLoginFormValidation
enum LDRLoginFormValidation {
    case success
    case failure(message: String)
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}

// MARK: - LDRLoginFormValidationErrorClosure
typealias LDRLoginFormValidationErrorClosure = () -> String

// MARK: - LDRLoginFormValidationPublisher
typealias LDRLoginFormValidationPublisher = AnyPublisher<LDRLoginFormValidation, Never>

// MARK: - LDRLoginFormValidationPublisher
extension LDRLoginFormValidationPublisher {
    
    // MARK: static api
    
    /// Checks if the value is empty or not
    /// - Parameters:
    ///     - publisher: Published<String>.Publisher
    ///     - errorMessage: LDRLoginFormValidationErrorClosure
    /// - Returns: LDRLoginFormValidationPublisher
    static func nonEmptyValidation(
        for publisher: Published<String>.Publisher,
        errorMessage: @autoclosure @escaping LDRLoginFormValidationErrorClosure
    ) -> LDRLoginFormValidationPublisher {
        publisher.map { value in
            value.isEmpty ? .failure(message: errorMessage()) : .success
        }
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    /// Checks if the value is empty or not
    /// - Parameters:
    ///     - publisher: Published<String>.Publisher
    ///     - errorMessage: LDRLoginFormValidationErrorClosure
    /// - Returns: LDRLoginFormValidationPublisher
    static func domainValidation(
        for publisher: Published<String>.Publisher,
        errorMessage: @autoclosure @escaping LDRLoginFormValidationErrorClosure
    ) -> LDRLoginFormValidationPublisher {
        publisher.map { value in
            guard let url = URL(string: "https://\(value)") else {
                return .failure(message: errorMessage())
            }
            return UIApplication.shared.canOpenURL(url) ? .success : .failure(message: errorMessage())
        }
            .dropFirst()
            .eraseToAnyPublisher()
    }
}

// MARK: - Published.Publisher + String
extension Published.Publisher where Value == String {
    
    // MARK: public api
    
    /// Checks if the value is empty or not
    /// - Parameters:
    ///     - errorMessage: LDRLoginFormValidationErrorClosure
    /// - Returns: LDRLoginFormValidationPublisher
    func nonEmptyValidator(
        _ errorMessage: @autoclosure @escaping LDRLoginFormValidationErrorClosure
    ) -> LDRLoginFormValidationPublisher {
        LDRLoginFormValidationPublisher.nonEmptyValidation(for: self, errorMessage: errorMessage())
    }
    
    /// Checks if the value is empty or not
    /// - Parameters:
    ///     - errorMessage: LDRLoginFormValidationErrorClosure
    /// - Returns: LDRLoginFormValidationPublisher
    func domainValidator(
        _ errorMessage: @autoclosure @escaping LDRLoginFormValidationErrorClosure
    ) -> LDRLoginFormValidationPublisher {
        LDRLoginFormValidationPublisher.domainValidation(for: self, errorMessage: errorMessage())
    }
}

// MARK: - LDRLoginFormValidationModifier
struct LDRLoginFormValidationModifier: ViewModifier {
    // MARK: property
    @State var latestValidation: LDRLoginFormValidation = .success
    let validationPublisher: LDRLoginFormValidationPublisher
    
    var validationMessage: some View {
        switch latestValidation {
        case .success:
            return AnyView(EmptyView())
        case .failure(let message):
            let text = Text(message)
                .foregroundColor(.red)
                .font(.caption)
            return AnyView(text)
        }
    }
    
    // MARK: public api
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            validationMessage
        }.onReceive(validationPublisher) { validation in
            latestValidation = validation
        }
    }
}

// MARK: - TextField + LDRLoginFormValidation
extension TextField {
    // MARK: public api
    func validation(loginFormValidationPublisher: LDRLoginFormValidationPublisher) -> some View {
        modifier(LDRLoginFormValidationModifier(validationPublisher: loginFormValidationPublisher))
    }
}

// MARK: - SecureField + LDRLoginFormValidation
extension SecureField {
    // MARK: public api
    func validation(loginFormValidationPublisher: LDRLoginFormValidationPublisher) -> some View {
        modifier(LDRLoginFormValidationModifier(validationPublisher: loginFormValidationPublisher))
    }
}
