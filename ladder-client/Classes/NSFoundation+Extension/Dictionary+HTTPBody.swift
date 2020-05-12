import Foundation


// MARK: - Dictionary+HTTPBody
extension Dictionary {


    // MARK: - public api

    /// transform hash into Data for Request Body
    ///
    /// - Returns: Data for Request Body
    func HTTPBodyValue() -> Data? {
        var data: Data? = nil
        do { data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) }
        catch { data = nil }
        return data
    }

}

