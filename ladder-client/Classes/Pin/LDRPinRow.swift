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
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 64, alignment: .leading)
          .padding(.horizontal, 16.0)
          .lineLimit(2)
          .truncationMode(.tail)
      }
    )
    .frame(minWidth: 0, maxWidth: .infinity)
  }
  
  // MARK: public api
  
  func onTap(perform action: @escaping () -> Void) -> some View {
    onReceive(tapPublisher) { action() }
  }
}

// MARK: - LDRPinRow_Previews
struct LDRPinRow_Previews: PreviewProvider {
  static var previews: some View {
    LDRPinRow(title: "Rails アプリでオンラインでカラムの削除やリネームを行うには - eagletmt's blog")
  }
}

// MARK: - LDRPinRowShortTitle_Previews
struct LDRPinRowShortTitle_Previews: PreviewProvider {
  static var previews: some View {
    LDRPinRow(title: "Rails - eagletmt's blog")
  }
}

// MARK: - LDRPinRowLongTitle_Previews
struct LDRPinRowLongTitle_Previews: PreviewProvider {
  static var previews: some View {
    LDRPinRow(title: "Rails アプリでオンラインでカラムの削除やリネームを行うには - eagletmt's blog あいうえお かきくけこ さしすせそ たちつてと あいうえお かきくけこ さしすせそ たちつてと")
  }
}
