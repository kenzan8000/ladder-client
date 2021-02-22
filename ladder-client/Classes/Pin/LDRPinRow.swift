import Combine
import SwiftUI

// MARK: - LDRPinRow
struct LDRPinRow: View {
  // MARK: property

  var title: String
  let tapPublisher = PassthroughSubject<Void, Never>()

  var body: some View {
    Button(
      action: {
        tapPublisher.send()
      },
      label: {
        Text(title)
          .fixedSize(horizontal: false, vertical: true)
          .frame(height: 64)
          .lineLimit(2)
          .truncationMode(.tail)
      }
    )
  }
  
  // MARK: public api
  
  func onTap(perform action: @escaping () -> Void) -> some View {
    onReceive(tapPublisher) { action() }
  }
}

// MARK: - LDRPinRow_Previews
struct LDRPinRow_Previews: PreviewProvider {
  static var previews: some View {
    LDRPinRow(title: "Rails アプリでオンラインでカラムの削除やリネームを行うには - eagletmt's blog あいうえお かきくけこ さしすせそ たちつてと あいうえお かきくけこ さしすせそ たちつてと")
  }
}
