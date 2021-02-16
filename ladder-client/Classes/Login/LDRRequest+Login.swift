// MARK: - DRRequest + Login
extension LDRRequest where Response == URLResponse {
  // MARK: static api
  
  /// Login Request
  /// - Parameters:
  ///   - username: username string
  ///   - password: password string
  /// - Returns: 
  static func login(username: String, password: String) -> Self {
    LDRRequest(
      url: URL(ldrPath: LDR.login),
      method: .get(
        [
          .init(name: "username", value: username),
          .init(name: "password", value: password),
        ]
      )
    )
  }
}

// MARK: - LDRRequest + Session
extension LDRRequest where Response == Data {
  // MARK: static api
  
  /// Session Request
  /// - Parameters:
  ///   - username: username string
  ///   - password: password string
  ///   - authencityToken: authencityToken string
  /// - Returns:
  static func session(username: String, password: String, authenticityToken: String) -> Self {
    LDRRequest(
      url: URL(ldrPath: LDR.session),
      method: .post(
        ["username": username, "password": password, "authenticity_token": authenticityToken].HTTPBodyValue()
      )
    )
  }
}
