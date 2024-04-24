import Foundation

// MARK: - SignInDomainTextFieldViewModel

class SignInDomainTextFieldViewModel: ObservableObject {
    // MARK: - Public properties

    /// Input domain and path on the textfield
    @Published var domainAndPath = ""
}
