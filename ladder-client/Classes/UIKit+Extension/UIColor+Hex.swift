import UIKit


// MARK: - UIColor+Hex
extension UIColor {
    
    // MARK: - property
    
    var hexString: String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        
        return String(format: "#%06x", rgb)
    }
    
    // MARK: - initialization
    
    /// Initialization with hexdecimal String and alpha
    ///
    /// - Parameters:
    ///   - hexString: hexString like #123456
    ///   - alpha: alpha represented in CGFloat number
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexString.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        ).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        let filteredStr = hexString.filter { "aAbBcCdDeEfF0123456789".contains($0) }
        guard hexFormatted.count == filteredStr.count, hexString.count == 6 else {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
        
}
