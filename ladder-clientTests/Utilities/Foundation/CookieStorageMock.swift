import Foundation
@testable import ladder_client

// MARK: - CookieStorageMock

final class CookieStorageMock: CookieStorageProtocol {
    var cookies = [HTTPCookie]()
    
    func cookieString(host: String?) -> String? {
        guard let host else {
            return nil
        }
        return cookies.filter { $0.domain.hasSuffix(host) }
            .map { "\($0.name)=\($0.value);" }
            .reduce("", +)
    }
    
    func addCookies(urlResponse: URLResponse) {
        guard let response = urlResponse as? HTTPURLResponse,
        let host = response.url?.host else {
            return
        }
        let headerFields = (response.allHeaderFields as? [String: String]) ?? [:]
        for (key, value) in headerFields {
            let cookie = HTTPCookie(properties: [.name: key, .value: value, .domain: host, .path: "/session", .secure: true])!
            cookies.removeAll(where: { $0.name == cookie.name && $0.domain == cookie.domain })
            cookies.append(cookie)
        }
    }
}

// MARK: - URLResponse Extension

extension URLResponse {
    static let sessionResponse: HTTPURLResponse = {
        let url = URL(string: "https://fladder.herokuapp.com/session")!
        return HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: [.sessionResponseCookieKey: .sessionResponseCookieValue]
        )!
    }()
}

extension String {
    static let sessionResponseCookieKey: String = "_fastladder_session"
    static let sessionResponseCookieValue: String = "gpUkw9ebSctbu%2FknOvete6jQ5q6yTi0JCZQP5FVq75WMNWoDumyxkVh2oVBr6HbTYqThSUNbxPXtRA2BrVnpjV9HcFsLQpXOVCSk84sLwV7L2ys60v8Kwsrnyf%2Bm8RXXr%2FJIk50hvo158MZ7C1R%2FDveM7DyXnwKMpPMiCOoYAhB7IJ0KhQuO7fqHnKwzFHJ%2FObcO%2FsRdtU%2FlI8JHaRPo%2BlHhhVa6Vb4Jc2dSDIQTocp7hXEDQGgElhbtPsT%2BJXWfAw%2BVmG1YTLfooa8qZ3shwcTaKmxGV5SU80HLz8oXfJaeu0DAtBaTZOpOyplxyVJqRxQHw5gbsr8cJNs73WoTnERYxXXbxYpTeS9nOuz%2BRCNNQY0oPiEnE0GgVVUqJAwZ2XYETXqhJA%2FxfVx8wtOLMhjRbAjblzI9IgFfjMnVRKwC5wTbKaPzXr3AT%2FwE3Dss07XE2AmfsePdSRuzuA%3D%3D--UvCNa%2FwlKIxuNcbJ--vl7w4BODUQnA%2FhKmYv%2Fomw%3D%3D"
    static let sessionResponseCookie: String = "\(String.sessionResponseCookieKey)=\(String.sessionResponseCookieValue);"
}
