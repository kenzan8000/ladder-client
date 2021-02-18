import Combine
import SwiftUI

// MARK: - LDRLoginViewModel
final class LDRLoginViewModel: ObservableObject {
    
  // MARK: - model
    
  @Published var urlDomain = LDRRequestHelper.getLDRDomain() ?? ""
  @Published var username = ""
  @Published var password = ""
  @Published var isLogingIn = false
  @Published var error: Error?
  var isPresentingAlert: Binding<Bool> {
    Binding<Bool>(get: {
      self.error != nil
    }, set: { newValue in
      if !newValue {
        self.error = nil
      }
    })
  }
  
  private var authencityToken = ""
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: destruction
  
  deinit {
    cancellables.forEach { $0.cancel() }
  }
  
  // MARK: - public api

  /// logins
  func login() {
    if isLogingIn {
      return
    }
    isLogingIn = true
    
    LDRRequestHelper.setUsername(username)
    LDRRequestHelper.setPassword(password)
    LDRRequestHelper.setURLDomain(urlDomain)
    
    requestAuthencityToken()
  }
  
  // MARK: - private api
  
  /// requests authencityToken
  private func requestAuthencityToken() {
    URLSession.shared.publisher(for: .login(username: username, password: password))
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] result in
          if case let .failure(error) = result {
            self?.fail(by: error)
          } else {
            self?.requestSession()
          }
        },
        receiveValue: { [weak self] response in
          self?.authencityToken = response.authencityToken
        }
      )
      .store(in: &cancellables)
  }
  
  /// requests session
  private func requestSession() {
    URLSession.shared.publisher(for: .session(username: username, password: password, authenticityToken: authencityToken))
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] error in
          if case let .failure(error) = error {
            self?.fail(by: error)
          } else {
            self?.succeed()
          }
        },
        receiveValue: {
          LDRRequestHelper.setApiKey($0.apiKey)
        }
      )
      .store(in: &cancellables)
  }
  
  /// calls when succeeded
  private func succeed() {
    isLogingIn = false
    NotificationCenter.default.post(name: LDRNotificationCenter.didLogin, object: nil)
  }
  
  /// calls when failed
  private func fail(by error: Swift.Error) {
    isLogingIn = false
    self.error = error
  }

}
