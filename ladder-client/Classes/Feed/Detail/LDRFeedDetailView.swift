import SwiftUI

// MARK: - LDRFeedDetailView
struct LDRFeedDetailView: View {
    
    var body: some View {
        Text("Hoge")
    }

}

// MARK: - LDRFeedDetailView_Previews
struct LDRFeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LDRFeedDetailView()
    }
}

// MARK: - LDRFeedDetailViewController
class LDRFeedDetailViewController: UIHostingController<LDRFeedDetailView> {

    // MARK: - initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(
            coder: aDecoder,
            rootView: LDRFeedDetailView()
        )
    }
}
