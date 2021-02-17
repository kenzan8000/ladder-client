import SwiftUI

// MARK: - LDRLoginViewModel
final class LDRLoginViewModel: ObservableObject {
    
  // MARK: - model
    
  @Published var urlDomain = ""
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
    
  // MARK: - public api

  /// start login
  func startLogin() {
    if self.isLogingIn {
      return
    }
    self.isLogingIn = true
    
    // URLSession.shared.publisher(for: LDRRequest.login(username: username, password: password))
    // login.start { [unowned self] _, error in
    //   self.isLogingIn = false
    //   self.error = error
    // }
  }
    
  /// end login
  func endLogin() {
    // login.end()
  }
}
