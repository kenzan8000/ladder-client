import Combine
import KeychainAccess
import SwiftUI

// MARK: - LDRLoginView + ViewModel
extension LDRLoginView {
  // MARK: ViewModel
  class ViewModel: ObservableObject {
      
    // MARK: - model
    private var keychain: LDRKeychain
    
    @Published var urlDomain = ""
    @Published var username = ""
    @Published var password = ""
    @Published var error: LDRError?
    var isPresentingAlert: Binding<Bool> {
      Binding<Bool>(get: {
        self.error != nil
      }, set: { newValue in
        if !newValue {
          self.error = nil
        }
      })
    }
    @Published var isLogingIn = false
    @Published var loginDisabled = true

    lazy var urlDomainValidation: LDRLoginFormValidationPublisher = {
      $urlDomain.domainValidator("Fastladder URL must be provided.")
    }()
    lazy var usernameValidation: LDRLoginFormValidationPublisher = {
      $username.nonEmptyValidator("username must be provided.")
    }()
    lazy var passwordValidation: LDRLoginFormValidationPublisher = {
      $password.nonEmptyValidator("password must be provided.")
    }()
    lazy var allValidation: LDRLoginFormValidationPublisher = {
      Publishers.CombineLatest3(
        urlDomainValidation,
        usernameValidation,
        passwordValidation
      ).map { v1, v2, v3 in
        [v1, v2, v3].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
      }.eraseToAnyPublisher()
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var loginResponse: LDRLoginResponse?
    
    // MARK: initializer
    
    init(keychain: LDRKeychain) {
      self.keychain = keychain
    }
    
    // MARK: destruction
    
    deinit {
      tearDown()
    }
    
    // MARK: - public api

    /// logins
    func login() {
      isLogingIn = true
      
      keychain.ldrUrlString = urlDomain

      HTTPCookieStorage.shared.removeCookies(since: .init(timeIntervalSince1970: 0))
      
      URLSession.shared.publisher(for: .login(ldrUrlString: urlDomain, username: username, password: password), ldrUrlString: urlDomain)
        .receive(on: DispatchQueue.main)
        .sink(
          receiveCompletion: { [weak self] result in
            if case let .failure(error) = result {
              self?.fail(by: error)
            } else {
              self?.succeed()
            }
          },
          receiveValue: { [weak self] in
            self?.keychain.apiKey = $0.apiKey
          }
        )
        .store(in: &cancellables)
    }
    
    /// calls when tearing down
    func tearDown() {
      cancellables.forEach { $0.cancel() }
      isLogingIn = false
      error = nil
    }
    
    // MARK: - private api

    /// calls when succeeded
    private func succeed() {
      tearDown()
      NotificationCenter.default.post(name: .ldrDidLogin, object: nil)
    }
    
    /// calls when failed
    private func fail(by error: LDRError) {
      isLogingIn = false
      self.error = error
    }

  }
}
