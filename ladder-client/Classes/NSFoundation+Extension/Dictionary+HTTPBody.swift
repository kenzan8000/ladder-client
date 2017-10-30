import Foundation


/// MARK: - Dictionary+HTTPBody
extension Dictionary {


    /// MARK: - public api

    /**
     * transform hash into Data for Request Body
     * @return Data?
     **/
    func HTTPBodyValue() -> Data? {
        var queryCount = 0
        var HTTPBodyString = ""
        for (key, value) in self {
            let keyValue = "\("\(key)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))=\("\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))"
            HTTPBodyString = HTTPBodyString + ((queryCount == 0) ? "?\(keyValue)" : "&\(keyValue)")
            queryCount = queryCount + 1
        }
        return HTTPBodyString.data(using: .utf8)
    }

}

