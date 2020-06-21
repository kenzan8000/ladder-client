import SwiftUI

// MARK: - LDRPinRow
struct LDRPinRow: View {
    var title: String
    
    var body: some View {
        Text(title)
    }
}

// MARK: - LDRPinRow_Previews
struct LDRPinRow_Previews: PreviewProvider {
    static var previews: some View {
        LDRPinRow(title: "Rails アプリでオンラインでカラムの削除やリネームを行うには - eagletmt's blog")
    }
}
