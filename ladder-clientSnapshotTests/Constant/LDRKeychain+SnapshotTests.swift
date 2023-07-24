import KeychainAccess
@testable import ladder_client

// MARK: - Keychain + LDR
extension Keychain {
    static let test = Keychain(service: LDR.service, accessGroup: LDR.testGroup)
}
