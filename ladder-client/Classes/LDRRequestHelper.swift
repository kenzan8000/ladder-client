import Alamofire
import KeychainAccess

// MARK: - LDRRequestHelper
class LDRRequestHelper: Any {
    
    // MARK: - class method
    
    /// Sets LDR api key to keychain
    ///
    /// - Parameter apiKey: LDR apiKey String
    class func setApiKey(_ apiKey: String) {
        Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.apiKey] = apiKey
    }
    
    /// Sets LDR user name
    ///
    /// - Parameter apiKey: LDR user name String
    class func setUsername(_ username: String) {
        Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.username] = username
    }
    
    /// Sets LDR password
    ///
    /// - Parameter apiKey: LDR password String
    class func setPassword(_ password: String) {
        Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.password] = password
    }
    
    /// Sets LDR url domain
    ///
    /// - Parameter apiKey: LDR url domain String
    class func setURLDomain(_ urlDomain: String) {
        var domain = urlDomain + ""
        while domain.hasSuffix("/") {
            domain = String(domain.dropLast(1))
        }
        Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.ldrUrlString] = domain
    }
    
    /// Returns LDR api key
    ///
    /// - Returns: Returns LDR api key string or nil
    class func getApiKey() -> String? {
        guard let apiKey = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.apiKey] else {
            return nil
        }
        if apiKey.isEmpty {
            return nil
        }
        return apiKey
    }

    /// Returns LDR user name
    ///
    /// - Returns: Returns LDR username string or nil
    class func getUsername() -> String? {
        guard let username = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.username] else {
            return nil
        }
        if username.isEmpty {
            return nil
        }
        return username
    }
    
    /// Returns LDR password
    ///
    /// - Returns: Returns LDR password string or nil
    class func getPassword() -> String? {
        guard let password = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.password] else {
            return nil
        }
        if password.isEmpty {
            return nil
        }
        return password
    }
    
    /// Returns LDR url domain
    ///
    /// - Returns: Returns LDR url domain string or nil
    class func getLDRDomain() -> String? {
        guard let password = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
        )[LDRKeychain.ldrUrlString] else {
            return nil
        }
        if password.isEmpty {
            return nil
        }
        return password
    }

    /// Returns LDR HttpHeader
    ///
    /// - Parameter httpBody: httpBody to request
    /// - Returns: Returns LDR HttpHeader
    class func createHttpHeader(httpBody: Data?) -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        headers.add(name: "Content-Length", value: "\(String(describing: httpBody?.count))")
        return headers
    }
    
    /// Returns LDR HttpHeader with Cookie
    ///
    /// - Parameters:
    ///   - url: url to request
    ///   - httpBody: httpBody to request
    /// - Returns: Returns LDR HttpHeader with Cookie
    class func createCookieHttpHeader(url: URL, httpBody: Data?) -> HTTPHeaders {
        var headers = HTTPHeaders()
        if let cookieHeader = URLRequest.getCookies(host: url.host) {
            headers.add(cookieHeader)
        }
        headers.add(name: "Content-Type", value: "application/json")
        headers.add(name: "Content-Length", value: "\(String(describing: httpBody?.count))")
        return headers
    }
    
    /// returns built ldr url
    ///
    /// - Parameters:
    ///   - path: path of url
    ///   - params: quries of url
    /// - Returns: built ldr url
    class func createUrl(path: String, params: [String: String] = [:]) -> URL? {
        // if params.count == 0 { return nil }
        
        guard let ldrUrlString = Keychain(
            service: LDRKeychain.serviceName,
            accessGroup: LDRKeychain.suiteName
            )[LDRKeychain.ldrUrlString] else {
            return nil
        }

        guard let url = URL(string: "https://" + ldrUrlString + "\(path)") else {
            return nil
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = params.map {
            URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
